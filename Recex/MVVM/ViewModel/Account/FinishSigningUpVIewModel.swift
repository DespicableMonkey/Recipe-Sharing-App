//
//  FinishSigningUpVIewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/27/21.
//

import Foundation
import SwiftUI
import PromiseKit
import Combine

class FinishSigningUpViewModel : ObservableObject {
    let user : User = .shared
    @Published var username : String = ""
    @Published var profileImage : UIImage = UIImage()
    @Published var description : String = ""
    @Published var imgPicker : Bool = false
    @Published var alertText : String = ""
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    let query = Query()
    
    func finish() {
        self.alertText = ""
        if(self.username.trim().count < 3) {
            self.alertText = "Username must be at least 3 characters"
            return
        }
        let _ = create(completion: {
            (response, error) in
            if(error != nil) {}
            else {
                if(response == .customResponse1) {
                    self.alertText = "Sorry, that username already exists"
                } else if(response == .success) {
                    AS.set(for: "FinishedSignUp", true)
                    self.shouldDismissView = true
                } else {
                    self.alertText = "Oops, The Server Failed to Respond"
                }
            }
        })
        
    }
    func create(completion: @escaping(validationResponses, _ error: Error?) -> (Void)) -> validationResponses {
        var data : [String: String] = [:]
        data["username"] = self.username.trim()
        data["hasProfileImage"] = self.profileImage == UIImage() ? "FALSE" : "TRUE"
        data["bio"] = self.description
        data["user"] = (AS.retrieve(for: "PersonID") as! String)
        let json = BasicWithDictJSONModel(authentication_key: "-", request: "finish", data: data)
        guard let jsonData = try? JSONEncoder().encode(json) else { return .error }
        if(profileImage != UIImage()) {
            var imgs : [UIImage : String] = [:]
            imgs[profileImage] = "ProfileImage"
            
            firstly {
                query.RequestWithImage(urlString: Database.URLs["authenticationURL"] ?? "", jsonData: jsonData, jsonModel: BasicWithDictJSONModel.self, responseFormat: .basic, imageData: imgs)
            }.done{ (response : HTTPResponse) in
                guard let convertedResponse = (response as? BasicHTTPResponse) else { throw RuntimeError("Server Failed to Respond")}
                let verdict : validationResponses = {
                    switch(convertedResponse.result){
                    case "sign_up_finished": return .success
                    case "username_already_exists": return .customResponse1
                    case "error" : return .error
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
        } else {
            firstly {
                query.Request(urlString: Database.URLs["authenticationURL"] ?? "", jsonData: jsonData, jsonModel: BasicWithDictJSONModel.self, responseFormat: .basic)
            }.done{ (response : HTTPResponse) in
                guard let convertedResponse = (response as? BasicHTTPResponse) else { throw RuntimeError("Server Failed to Respond")}
                let verdict : validationResponses = {
                    switch(convertedResponse.result){
                    case "sign_up_finished": return .success
                    case "error" : return .error
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
        }
        return validationResponses.none
        
    }
}
