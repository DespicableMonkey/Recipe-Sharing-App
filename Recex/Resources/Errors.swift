//
//  Errors.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/26/20.
//

import Foundation
protocol customError : Error {
    var message : String { get set }
}
struct RuntimeError: Error, customError {
    var message : String
    
    init(_ message : String){
        self.message = message
    }
    
    public var localizedDescription : String { return message }
    public var description : String { return message }
}

struct Failure: Error, customError {
    var message: String
    
    init(_ message: String? = nil){ self.message = message ?? "expected_error" }
    
    public var localizedDescription : String { return message }
}
