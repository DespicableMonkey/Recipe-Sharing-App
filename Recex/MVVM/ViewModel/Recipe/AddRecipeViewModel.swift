//
//  AddRecipeViewswift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/25/20.
//

import Foundation
import SwiftUI
import UIKit
import PromiseKit
import Combine
import SPAlert

class AddRecipeViewModel : ObservableObject{
    
    var user : User = .shared
    
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
    
    @Published var disabledPublish : Bool = true
    
    var query = Query()
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldPopView = false {
        didSet {
            viewDismissalModePublisher.send(shouldPopView)
        }
    }
    
    func publishMediate() {
        if((recipeTitle.length > 0 && description.length > 0 && servings.length > 0 && difficulty.length > 0 && cookTime.length > 0 && ingredients.count > 0 && ingredients[0].length > 0 && steps.count > 0 && steps[0].length > 0)){
            let _ = publishRecipe(completion: {
                (response, error) in
                if(error != nil ) {
                    
                } else {
                    if response == .success {
                        SPAlert.present(title: "Recipe Published!", preset: .done)
                        self.shouldPopView = true
                    }
                }
            })
        } else {
            print("Button is Broken")
        }
    }
    
    func publishRecipe(completion: @escaping(validationResponses, _ error: Error?) -> (Void)) -> validationResponses {
        var stepsDictionary : [String : String] = [:]
        var stepImagesDictionary : [UIImage: String] = [:]
        for i in 0..<self.steps.count {
            stepsDictionary["\(i+1)"] = self.steps[i]
        }
        for i in 0..<self.stepImages.count {
            if(!(stepImages[i] == UIImage())) {
                stepImagesDictionary[self.stepImages[i]] = "step-image-\(i+1)"
            }
        }
        let publishRecipeRequestJSON = PublishRecipeRequestJSON(authentication_key: "-", request: "publish", recipe_name: self.recipeTitle, recipe_description: self.description, difficulty: self.difficulty, cook_time: self.cookTime, servings: self.servings, ingredients: self.ingredients, steps: stepsDictionary, creator_id: user.PersonID, publishedTo: "PUBLIC")
        guard let publishRecipeRequestJSONData = try? JSONEncoder().encode(publishRecipeRequestJSON) else { return .error }
        firstly {
            query.RequestWithImage(urlString: Database.URLs["publishRecipeURL"] ?? "", jsonData: publishRecipeRequestJSONData, jsonModel: PublishRecipeRequestJSON.self, responseFormat: .basic, imageData: stepImagesDictionary)
        }.done{ (response : HTTPResponse) in
            guard let convertedResponse = (response as? BasicHTTPResponse) else { throw RuntimeError("Server Failed to Respond")}
            let verdict : validationResponses = {
                switch(convertedResponse.result){
                case "recipe_published": return .success
                case "error" : return .error
                default: return .error
                }
            }()
            completion(verdict, nil)
        }.catch { (error : Error) in
            switch (error){
            case is RuntimeError: completion(.error, error)
            default: completion(.error, RuntimeError("Something Unknown Happened"))
            }
        }
        return validationResponses.none
        
    }
    
}
