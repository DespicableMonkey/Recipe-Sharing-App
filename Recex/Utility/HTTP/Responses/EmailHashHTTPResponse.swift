//
//  EmailHashHTTPResponse.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation

struct EmailHashHTTPResponse : Codable, HTTPResponse {
    var result: String;
    
    var salt : String? = nil;
}
