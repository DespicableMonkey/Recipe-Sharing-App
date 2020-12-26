//
//  IngredientsHTTPResponse.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/22/20.
//

import Foundation

struct IngredientsHTTPResponse : HTTPResponse, Codable {
    var result: String
    var ingredients_master : [String]
}
