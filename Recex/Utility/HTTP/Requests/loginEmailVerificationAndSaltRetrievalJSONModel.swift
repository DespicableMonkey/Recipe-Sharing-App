//
//  loginEmailVerificationAndSaltRetrievalJSONModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation

struct loginEmailVerificationAndSaltRetrievalJSONModel : Codable, Request {
    var authentication_key: String
    var request: String
    
    var email : String
}
