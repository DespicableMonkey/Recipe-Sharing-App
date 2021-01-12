//
//  AccountModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
import PromiseKit

struct AccountModel {
    let query = Query()
    var URLs : [String: String]
    init(urls : [String: String]){
        URLs = urls
    }
    func validateLogin(email: String, password: String, completion: @escaping(validationResponses,  _ error: Error?) -> (Void)) -> validationResponses? {
        let emailRequestJSON = loginEmailVerificationAndSaltRetrievalJSONModel(authentication_key: "-", request: requests[.emailHash] ?? "", email: email)
        guard let emailRequestJSONData = try? JSONEncoder().encode(emailRequestJSON) else { return nil }
        var login : validationResponses = .none
        firstly{
            query.Request(urlString: URLs["authenticationURL"] ?? "", jsonData: emailRequestJSONData, responseFormat: .emailHash)
        }.compactMap(){  (response : HTTPResponse) in
            guard let convertedResponse = (response as? EmailHashHTTPResponse) else { throw RuntimeError("Could Not Get Response")}
            guard let salt = convertedResponse.salt else { throw Failure("Invalid Login Credentials"); }
            let hash = hashPassword(salt: salt, auth_string: password)
            let passwordRequestJSON = loginPasswordVerificationJSONModel(authentication_key: "-", request: requests[.passwordValidation] ?? "",email: email,  hash: hash)
            let passwordRequestJSONData = try! JSONEncoder().encode(passwordRequestJSON)
            return passwordRequestJSONData
        }.then { (JSONData : Data) in
             query.Request(urlString: URLs["authenticationURL"] ?? "", jsonData: JSONData, responseFormat: .withInfo)
        }.done { (response : HTTPResponse) in
            guard let convertedResponse = (response as? ResponseWithInfoHTTPResponse) else { throw RuntimeError("Could Not Get A Response") }
            user_cons.PersonID = convertedResponse.info
            let verdict : validationResponses = convertedResponse.result == "Valid" ? .success : .fail
            completion(verdict, nil)
        }.catch { (error : Error) in
            switch (error){
                case is Failure: completion(.fail, error)
                case is RuntimeError: completion(.error, error)
                default: completion(.error, RuntimeError("Something Unknown Happened"))
            }
        }
        login = .success
        return login
    }
    
    func createAccount(email: String, password: String, completion: @escaping(validationResponses, _ error: Error?) -> (Void)) -> validationResponses {
        let hasher = Hasher()
        let hashAndSalt = hasher.Hash(key: password, genSalt: true)
        let registerRequestJSON = SignUpJSONModel(authentication_key: "_", request: requests[.signUp] ?? "", email: email, password: hashAndSalt[0], salt: hashAndSalt[1])
        guard let registerRequestJSONData = try? JSONEncoder().encode(registerRequestJSON) else { return .error }
        firstly {
            query.Request(urlString: URLs["authenticationURL"] ?? "", jsonData: registerRequestJSONData, responseFormat: .basic)
        }.done { (response : HTTPResponse) in
            guard let convertedResponse = (response as? BasicHTTPResponse) else { throw RuntimeError("Server Failed to Respond")}
            let verdict : validationResponses = {
                switch(convertedResponse.result){
                    case "account_created": return .success
                    case "account_exists" : return .customResponse1
                    default: return .error
                }
            }()
            completion(verdict, nil)
        }.catch { (error : Error) in
            switch (error){
                case is RuntimeError: completion(.error, error)
                default: completion(.error, RuntimeError("Something Unknown Happened"))
            }
        }
        return validationResponses.none
    }
    
    func hashPassword(salt : String, auth_string : String ) -> String{
        let hasher = Hasher()
        let response = hasher.Hash(key: auth_string, genSalt: false, salt: salt)
        if(response.count < 2) { return "error" }
        return response[0]
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

