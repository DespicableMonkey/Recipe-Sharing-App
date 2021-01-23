//
//  User.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

// For the Current Actual App User, not for the rest of the users

import Foundation
import PromiseKit

class User : Identifiable, Person, ObservableObject {
    
    // Not Including Authentication_String, application will query for that If User decides to Change Password
    
    //Person Protocol Elements
    var id = UUID()
    var PersonID: String
    var Firstname: String = ""
    var Lastname: String = ""
    var Email: String = ""
    var Creation: String = ""
    var Role: String = ""
    var SuggestionModelData: String = ""
    var Posts: [String] = []
    var Followers: [String] = []
    var Following: [String] = []
    var ShareIdentifier: String = ""
    
    //User Specific Element
    var PantryNeeded: [String: Int] = [:]
    var PantryOwned: [String: Int] = [:]
    var PantryBookmarked: [String] = []
    
    
    var Preferences: [String: String] = [:]
    var Communities: [String: [String : String]] = [:]
    
    var ExtraData: [[[String]]]?
    
    //Havent Implemented These Yet
    var Messages: [[String]]?
    var ContactRequests: [String]?
    
    let db = Database()
    let query = Query()
    var URLs : [String: String]
    
    
    static let shared = User(PersonID: "-1", Firstname: "", Lastname: "", Email: "", Creation: "", Role: "", SuggestionModelData: "", Posts: [], Followers: [], Following: [], ShareIdentifier: "", PantryNeeded: [:], PantryOwned: [:], Preferences: [:], Communities: [:])
    
    //Init With All Expected Value
    init(PersonID: String, Firstname: String, Lastname: String, Email:String, Creation:String, Role:String, SuggestionModelData:String, Posts:[String], Followers: [String], Following: [String], ShareIdentifier: String, PantryNeeded: [String : Int], PantryOwned : [String : Int], Preferences:[String: String], Communities: [String: [String: String]]) {

        URLs = db.urlDict
        
        self.PersonID = PersonID
        self.Firstname = Firstname
        self.Lastname = Lastname
        self.Email = Email
        self.Creation = Creation
        self.Role = Role
        self.SuggestionModelData = SuggestionModelData
        self.Posts = Posts
        self.Followers = Followers
        self.Following = Following
        self.ShareIdentifier = ShareIdentifier

        self.PantryNeeded = PantryNeeded
        self.PantryOwned = PantryOwned
        self.Preferences = Preferences
        self.Communities = Communities


    }
    init(PersonID : String) {
        URLs = db.urlDict
        self.PersonID = PersonID
        self.fetchData()
    }
    
    static func reFetchData() {
        
    }
    
    func fetchData() {
        let _ = queryData(completion: {
            (response, error) in
            if(error != nil ) {
            } else {
                let userData = response as! UserDataResponse
                let user : User = .shared
                user.PersonID = user_cons.PersonID
                user.Firstname = userData.Firstname
                user.Lastname = userData.Lastname
                user.Email = userData.Email
                user.Creation = userData.Created
                user.Communities = userData.Communities
                
            }
        })
    }
    func queryData ( completion: @escaping(HTTPResponse, _ _error: Error?) -> (Void)) -> validationResponses? {
        let fetchDataRequestJ =  FetchUserJSONModel(authentication_key: "-", request: requests[.user] ?? "", ID: "\(user_cons.PersonID)")
        guard let fetchDataRequestJSON = try? JSONEncoder().encode(fetchDataRequestJ) else { return nil }

        firstly {
            query.Request(urlString: URLs["fetchUserDataURL"] ?? "", jsonData: fetchDataRequestJSON, responseFormat: .user)
        }.done { (response : HTTPResponse) in
            guard let convertedResponse = (response as? UserDataResponse) else {
                throw RuntimeError("Failed to connect to the Server")
            }
            completion(convertedResponse, nil)
            
        }.catch { (error : Error) in
            switch (error){
            case is RuntimeError: completion(ErrorHTTPResponse(), error)
                default: completion(ErrorHTTPResponse(), RuntimeError("Something Unknown Happened"))
            }
    }
        return .success
    }
}

 struct user_cons {
   static var PersonID : String = "-1"
}
