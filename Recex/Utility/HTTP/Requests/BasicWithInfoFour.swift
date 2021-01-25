//
//  BasicWithInfoFour.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/12/21.
//

import Foundation

struct BasicWithInfoFourJSONModel : Request, Codable, Loopable {
    var authentication_key: String
    var request: String
    var info_one : String
    var info_two: String
    var info_three: String
    var info_four: String
}

