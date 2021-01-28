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
    //data for the search
    @Published var ingredients : [Ingredient] = []
    @Published var searchedIngredients : [Ingredient] = []
    @Published var searchText = ""
    @Published var alertText = "Search & Explore Our Ingredients"
    var target : String = ""
    
    //create the databbbase and query objects
    let db = Database()
    let query = Query()
    var URLs : [String: String]
    
    
    init() {
        //fetch the ingredients list
        URLs = db.urlDict
        self.fetchIngredients()
        
        //make sure the user has the dicts for the needed and owned ingredient lists
        AS.verifyItemExists(for: "needed_ingredients", as: [String: Double].self, otherwise: [:])
        AS.verifyItemExists(for: "owned_ingredients", as: [String: Double].self, otherwise: [:])
        
        
    }
    /**
     Function to call another function to get the ingredients. This function houses the completion handler
     */
    func fetchIngredients () {
        //call the function to fetch the ingredients from the api
        let _ = queryIngredients(completion: {
             (response, error) in
            
            if(error != nil){
                //Failed to Retrieve a Response
            } else {
                //result lisrt as array from the server
                let ingredientsUnconverted = response as! IngredientsHTTPResponse
                let ingredientsList = ingredientsUnconverted.ingredients_master
                
                //Having a temp array to prevent mass refresh and any subseqent freezing from updating the published var constantly
                var ingredientsTemp : [Ingredient] = []
                //append eahc ingredient to the list
                for ingredient in ingredientsList {
                    ingredientsTemp.append(Ingredient(name: ingredient, quantity: 1, unit: "", image: nil))
                }
                self.ingredients = ingredientsTemp
            }
        })
    }
    /**
     Queries the ingredients from the server
     - Parameters
        - completion: handler after a response or a error was recieved
     - Returns:
        - validationResponses: as to wether the query was successfully send
     */
    func queryIngredients (completion: @escaping(HTTPResponse, _ _error:Error?) -> (Void)) -> validationResponses? {
        //convert the request into json and data
        let ingredientRequestJSON = BasicJSONModel(authentication_key: "-", request: requests[.fetch] ?? "")
        guard let ingredientRequestJSONData = try? JSONEncoder().encode(ingredientRequestJSON) else { return .error}
        
        //query the request
        firstly {
            query.Request(urlString: URLs["public_api-ingredientsURL"] ?? "", jsonData: ingredientRequestJSONData, jsonModel: BasicJSONModel.self, responseFormat: .ingredients)
        }.done { (response : HTTPResponse) in
            //response was received - convert it into expected format
            guard let convertedResponse = (response as? IngredientsHTTPResponse) else { throw RuntimeError("Error Retrieving Ingredients")}
            //givr the completion handler the response
            completion(convertedResponse, nil) 
        }.catch{(error : Error) in
            //an error was thrown
            switch(error){
            case is RuntimeError: completion(ErrorHTTPResponse(),  RuntimeError("Error Retrieving Ingredients"))
            default: completion(BasicHTTPResponse(result: "error"), RuntimeError("Something Unknown Happened"))
            }
        }
        //query successfully completed
        return validationResponses.none
    }
    
    /**
    filter the lit to the ingredients searched in the search bar
     - Returns :
        - a array of ingredients that corresponds to the term in the search bar
     */
    func searchIngredients() -> [Ingredient] {
        //filters the ingredients to see if it matches the search term
        let arr : [Ingredient] = ingredients.filter({ searchText.isEmpty ? true : $0.name.lowercased().contains(searchText.lowercased()) })
        //sorts the ingreidnets to most likely to be the seatrch term
        let result = arr.sorted { ($0.name.hasPrefix(searchText) ? 0 : 1) < ($1.name.hasPrefix(searchText) ? 0 : 1)}
        
        //to prevent hitches on slower/older phones when queries are small and therefore result lists are quite large
        if(result.count > 200){
            return Array(result[0..<200])
        }
        //rejturn the ingredient list
        return result
    }
    /**
     updates the actual list view with the ingredients returned
     - Parameters:
        - key: which array to update(needed or owned ingredients)
        - ingredient: Which ingredient to add/remove
        - action: true = add, false = remove
        - byNumber, if its an addition/subtraction from the ammount as opposed to removing/adding to thee list
        - amount: If bynumber is true, add this much to the amount
     */
    
    func updateList(for key: String, ingredient: String, action: Bool, by number: Bool? = nil, amount: Double? = nil) {
        //get the currrent list
        guard var dict : [String: Double] = AS.retrieve(for: key) as? [String : Double] else {
            return }
        //do the actions
        if(action){  dict[ingredient] = Double(1) }
        else {dict.removeValue(forKey: ingredient) }
        //set the list
        AS.set(for: key, dict)
    }
    /**
     Chreks if the list already contains a value
     - Parameters:
        - key: which array to search(needed or owned ingredients)
        - ingreident: WHich ingredient to search for
     - Returns:
        - wether the array contains the ingredients
     */
    
    func containsValue(for key: String, ingredient: String) -> Bool {
        //retireve the current list
        guard let dict : [String: Double] = AS.retrieve(for: key) as? [String : Double] else { return false }
        //check if list contains element
        if(dict[ingredient] != nil) { return true }
        return false
    }
}
