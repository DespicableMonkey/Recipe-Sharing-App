//
//  BasicJSONModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/21/20.
//

import Foundation

struct BasicJSONModel : Request, Codable, Loopable {
    var authentication_key: String
    var request: String
}
