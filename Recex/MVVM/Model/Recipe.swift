//
//  Recipe.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/24/20.
//

import Foundation
import SwiftUI

struct Recipe {
    var image : String?
    var title : String
    var detail: String
    var upvotes : Int
    var type : String
    var color : Color
    var time : Int
    var timeUnit : String
    
    var creator : String
    var creatorImage : String?
    var createdByUser : Bool
    var creation : String
    
    var expand : Bool
    
}

var TopRecipes = [
    Recipe(image: nil, title: "Chocolate Lava Cake", detail: "A Gentle Combinated of Various Ingredients", upvotes: 0, type: "easy", color: Color(.blue), time: 30, timeUnit: "minutes", creator: "Despicable", creatorImage: nil, createdByUser: true, creation: "2 Hours Ago", expand: false),
    
    Recipe(image: nil, title: "Buffaflo Pizza", detail: "A Gentle Combinated of Various Ingredients", upvotes: 5, type: "medium", color: Color(.yellow), time: 2, timeUnit: "hours", creator: "Babji", creatorImage: nil, createdByUser: false, creation: "Yesterday", expand: false)

]

