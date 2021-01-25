//
//  BasicWithInfoJSONModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/12/21.
//

import Foundation

struct BasicWithInfoJSONModel : Request, Codable, Loopable {
    var authentication_key: String
    var request: String
    var info : String
}
