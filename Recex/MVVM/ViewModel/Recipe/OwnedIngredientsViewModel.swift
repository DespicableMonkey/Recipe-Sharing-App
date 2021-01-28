//
//  OwnedIngredientsViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/28/21.
//

import Foundation
class OwnedIngredientsViewModel: ObservableObject {
    
    //getds the list of ingredients from the search query
    @Published var ingredients : [IngredientSimplified] = []
    
    init() {
        self.getIngredients()
    }
    /**
     Search for Ingredients and put them in the results list for owned ingredients
     */
    func getIngredients() {
        ingredients = []
        if let dict = (AS.retrieve(for: "owned_ingredients") as? [String: Double]) {
            for(name, amount) in dict {
                ingredients.append(IngredientSimplified(name: name, quantity: amount, offset: 0))
            }
        }
    }
    
    
}
