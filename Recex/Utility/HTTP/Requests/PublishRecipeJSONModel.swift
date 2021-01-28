//
//  PublishRecipeJSONModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/28/21.
//

import Foundation
struct PublishRecipeRequestJSON : Request, Codable, Loopable  {
   var authentication_key: String
   
   
   var request: String
   
   //php/js stytle variable names
   var recipe_name: String
   var recipe_description: String
   var difficulty: String
   var cook_time: String
   var servings: String
   
   var ingredients: [String]
   var steps: [String: String]
   
   var creator_id : String
   var publishedTo : String
   
   
}
