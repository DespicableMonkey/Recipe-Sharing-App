//
//  RecipeSuggestion.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/28/21.
//

import Foundation
struct recipeSuggestion : Identifiable {
    var id = UUID()
    var creator : String
    var creator_image : UIImage? = UIImage()
    var profileImage : UIImage? = UIImage()
    var description : String
    var ingredients: [String: Double]
    var postDate: String
    var createdByUser : Bool
    var expand: Bool
}
