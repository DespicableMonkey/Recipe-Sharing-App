//
//  ResponseWithInfoHTTPResponse.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import Foundation

struct ResponseWithInfoHTTPResponse : HTTPResponse, Codable {
    var result: String
    
    var info : String
}
