//
//  IngredientsViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/21/20.
//

import Foundation
import PromiseKit
import SwiftUI

class IngredientsViewModel : ObservableObject {
    @Published var ingredients : [Ingredient] = []
    @Published var searchedIngredients : [Ingredient] = []
    @Published var searchText = ""
    @Published var alertText = "Search & Explore Our Ingredients"
    
    @Published var addedToNeeded : [Ingredient] = []
    
    let db = Database()
    let query = Query()
    var URLs : [String: String]
    
    init() {
        URLs = db.urlDict
        self.fetchIngredients()
    }
    func fetchIngredients () {
        
        let _ = queryIngredients(completion: {
             (response, error) in
            
            if(error != nil){
                //alert = "Failed to Retrieve a Response"
            } else {
                let ingredientsUnconverted = response as! IngredientsHTTPResponse
                let ingredientsList = ingredientsUnconverted.ingredients_master
                
                //Having a temp array to prevent mass refresh and any subseqent freezing from updating the published var constantly
                var ingredientsTemp : [Ingredient] = []
                for ingredient in ingredientsList {
                    ingredientsTemp.append(Ingredient(name: ingredient, quantity: 1, unit: "", image: nil, offset: 0, isSwiped: false))
                }
                self.ingredients = ingredientsTemp
            }
        })
    }
    func queryIngredients (completion: @escaping(HTTPResponse, _ _error:Error?) -> (Void)) -> validationResponses? {
        let ingredientRequestJSON = BasicJSONModel(authentication_key: "-", request: requests[.fetch] ?? "")
        guard let ingredientRequestJSONData = try? JSONEncoder().encode(ingredientRequestJSON) else { return .error}
        
        firstly {
            query.Request(urlString: URLs["public_api-ingredientsURL"] ?? "", jsonData: ingredientRequestJSONData, jsonModel: BasicJSONModel.self, responseFormat: .ingredients)
        }.done { (response : HTTPResponse) in
            guard let convertedResponse = (response as? IngredientsHTTPResponse) else { throw RuntimeError("Error Retrieving Ingredients")}
            completion(convertedResponse, nil) 
        }.catch{(error : Error) in
            switch(error){
            case is RuntimeError: completion(ErrorHTTPResponse(),  RuntimeError("Error Retrieving Ingredients"))
            default: completion(BasicHTTPResponse(result: "error"), RuntimeError("Something Unknown Happened"))
            }
        }
        return validationResponses.none
    }
    func searchIngredients() -> [Ingredient] {
        let arr : [Ingredient] = ingredients.filter({ searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) })
        let result = arr.sorted { ($0.name.hasPrefix(searchText) ? 0 : 1) < ($1.name.hasPrefix(searchText) ? 0 : 1)}
        return result
    }
}
