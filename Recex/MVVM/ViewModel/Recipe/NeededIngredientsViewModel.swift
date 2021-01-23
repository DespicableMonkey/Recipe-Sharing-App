//
//  NeededIngredientsViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/2/20.
//

import Foundation
import SwiftUI

class NeededIngredientsViewModel: ObservableObject {
    //Testing Items
    
    @Published var ingredients = [
        Ingredient(name: "Eggs", quantity: 3.4, unit: "Items", image: "Nope", offset: 0, isSwiped: false),
        Ingredient(name: "Milk", quantity: 8, unit: "Cartons", image: "Nope", offset: 0, isSwiped: false),
        Ingredient(name: "Chicken", quantity: 1, unit: "Pound(s)", image: "Nope", offset: 0, isSwiped: false),
        ≈Ingredient(name: "Mashed Potatoes", quantity: 27, unit: "Grams", image: "Nope", offset: 0, isSwiped: false)

    ]
    
    
}
