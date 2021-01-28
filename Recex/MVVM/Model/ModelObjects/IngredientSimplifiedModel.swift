//
//  IngredientSimplifiedModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/28/21.
//

import Foundation
struct IngredientSimplified: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var quantity: Double
    
    var offset : CGFloat
    var isSwiped = false
}
