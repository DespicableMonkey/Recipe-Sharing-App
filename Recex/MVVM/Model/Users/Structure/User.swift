//
//  User.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

// For the Current Actual App User, not for the rest of the users

import Foundation

struct User : Identifiable, Person {
    
    // Not Including Authentication_String, application will query for that If User decides to Change Password
    
    //Person Protocol Elements
    var id = UUID()
    var PersonID: String
    var Firstname: String
    var Lastname: String
    var Email: String
    var Creation: String
    var Role: String
    var SuggestionModelData: String
    var Posts: [String]
    var Followers: [String]
    var Following: [String]
    var ShareIdentifier: String
    
    //User Specific Element
    var PantryList: [String]
    var Preferences: [String]
    var Communities: [[String]]
    
    var ExtraData: [[[String]]]?
    
    //Havent Implemented These Yet
    var Messages: [[String]]?
    var ContactRequests: [String]?
    
    
}

