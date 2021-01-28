//
//  Ingredient.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/29/20.
//

import Foundation
import SwiftUI

struct Ingredient: Identifiable {
    var id = UUID()
    var name : String
    var quantity : Double
    var unit : String
    
    var image : String?
    
    
}
