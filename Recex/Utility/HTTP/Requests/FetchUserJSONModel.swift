//
//  FetchUserJSONModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import Foundation

struct FetchUserJSONModel : Request, Codable, Loopable {
    var authentication_key: String
    var request: String
    var ID : String
}
