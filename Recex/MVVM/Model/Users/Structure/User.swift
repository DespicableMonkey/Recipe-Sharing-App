//
//  User.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

// For the Current Actual App User, not for the rest of the users

import Foundation

class User : Identifiable, Person, ObservableObject {
    
    // Not Including Authentication_String, application will query for that If User decides to Change Password
    
    //Person Protocol Elements
    var id = UUID()
    var PersonID: String = ""
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
    var Communities: [[String]] = [[]]
    
    var ExtraData: [[[String]]]?
    
    //Havent Implemented These Yet
    var Messages: [[String]]?
    var ContactRequests: [String]?
    
    
    static let shared = User()
    
    //Init With All Expected Value
//    init(PersonID: String, Firstname: String, Lastname: String, Email:String, Creation:String, Role:String, SuggestionModelData:String, Posts:[String], Followers: [String], Following: [String], ShareIdentifier: String, PantryList: [String], Preferences:[String: String], Communities: [[String]]) {
//
//        self.PersonID = PersonID
//        self.Firstname = Firstname
//        self.Lastname = Lastname
//        self.Email = Email
//        self.Creation = Creation
//        self.Role = Role
//        self.SuggestionModelData = SuggestionModelData
//        self.Posts = Posts
//        self.Followers = Followers
//        self.Following = Following
//        self.ShareIdentifier = ShareIdentifier
//
//        self.PantryList = PantryList
//        self.Preferences = Preferences
//        self.Communities = Communities
//
//
//    }
    
    
}
