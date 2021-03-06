//
//  NeededIngredientsViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/2/20.
//

import Foundation
import SwiftUI

class NeededIngredientsViewModel: ObservableObject {
    
    //gets the list of ingredients from the search query
    @Published var ingredients : [IngredientSimplified] = []
    
    init() {
        self.getIngredients()
    }
    
    /**
     Search for Ingredients and put them in the results list for needed ingredients
     */
    func getIngredients() {
        ingredients = []
        if let dict = (AS.retrieve(for: "needed_ingredients") as? [String: Double]) {
            for(name, amount) in dict {
                ingredients.append(IngredientSimplified(name: name, quantity: amount, offset: 0))
            }
        }
    }
    
    
}
