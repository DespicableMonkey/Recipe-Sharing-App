//
//  UserDataResponse.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import Foundation
struct UserDataResponse : HTTPResponse, Codable {
    var result: String
    
    var PersonID: String
    var Firstname: String
    var Lastname: String
    var Username: String
    var Email: String
    var Created: String
    var Communities:[String: [String: String]]
    var status: String
}
