//
//  AddRecipeViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/25/20.
//

import Foundation
import SwiftUI
import UIKit

class AddRecipeViewModel : ObservableObject{
    @Published var recipeTitle = ""
    @Published var description = ""
    @Published var difficulty = ""
    @Published var cookTime  = ""
    @Published var servings  = ""
    
    @Published var ingredients : [String] = [""]
    @Published var steps  : [String] = [""]
    @Published var stepTFHeights  : [CGFloat] = [0]
    
    @Published var stepImages  : [UIImage] = [UIImage()]
    @Published var stepImagePresents : [Bool] = [false]
    
    var disabledPublish : Bool = true
}