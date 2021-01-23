//
//  ResponseWithDetailsHTTPResponse.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/19/21.
//

import Foundation
struct ResponseWithDetailsHTTPResponse: Codable, HTTPResponse {
    var result: String
    var details: [[String: String]]
    
}

