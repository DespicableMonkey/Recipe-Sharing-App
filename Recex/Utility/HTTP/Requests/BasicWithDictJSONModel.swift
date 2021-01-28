//
//  BasicWithDictJSONModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/28/21.
//

import Foundation

struct BasicWithDictJSONModel : Request, Codable, Loopable {
    var authentication_key: String
    var request: String
    var data : [String : String]
    
    
}
