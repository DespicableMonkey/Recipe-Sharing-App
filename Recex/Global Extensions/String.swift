//
//  String.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
extension String {
    func sha256(salt: String) -> Data {
        return (self + salt).data(using: .utf8)!.sha256
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: (NSCharacterSet.whitespaces))
    }
    var length: Int { return self.count }
    
}
