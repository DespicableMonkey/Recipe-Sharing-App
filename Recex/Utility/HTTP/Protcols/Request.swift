//
//  Request.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
protocol Request : Codable, Loopable {
    var authentication_key : String { get set}
    var request : String { get set }
}
