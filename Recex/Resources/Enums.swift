//
//  Enums.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
enum responseFormats {
    case basic
    case emailHash
    case passwordValidation
    case signUp
    case fetch
    case ingredients
}

enum validationResponses {
    case success
    case fail
    case error
    case none
    
    case customResponse1
    case customResponse2
    case customResponse3
}
let requests : [responseFormats : String] = [
    .basic : "",
    .emailHash: "email_to_salt",
    .passwordValidation: "password_validation",
    .signUp: "sign_up",
    .fetch: "fetch"
]

