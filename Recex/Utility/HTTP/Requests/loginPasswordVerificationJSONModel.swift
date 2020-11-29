//
//  loginPasswordVerificationJSONModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation

struct loginPasswordVerificationJSONModel : Codable, Request {
    var authentication_key: String
    var request: String
    
    var email : String
    var hash : String
}
