//
//  HTTPResponse.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation

protocol HTTPResponse : Codable {
    var result: String { get set }
}
