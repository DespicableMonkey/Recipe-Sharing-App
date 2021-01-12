//
//  CreateCommunityViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import PromiseKit

class CreateCommunityViewModel : ObservableObject {
    @Published var communityName = ""
    @Published var communityDescription = ""
    @Published var communityIsPublic = false
    
    @Published var descriptionTFHeight : CGFloat = 0
    
    @Published var isLoading = false
    
    @Published var alertTxt = ""
    
    @Published var communityImage : UIImage = UIImage()
    @Published var imagePickerIsPresented : Bool = false
    
    @Published var user : User = .shared
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    var query = Query()
    
    private var shouldPopView = false {
        didSet {
            viewDismissalModePublisher.send(shouldPopView)
        }
    }
    
    func validateCreation() {
        self.alertTxt = ""
        if(communityName.trim().count < 3) {
            self.alertTxt = "Community Name must be at least 3 characters"
        } else if (communityDescription.trim().count < 1) {
            self.alertTxt = "Community Description cannot be blank"
        } else if (communityImage == UIImage()) {
            self.alertTxt = "Community must have an image"
        } else {
            self.createCommunityMediate()
            self.shouldPopView = true
        }
         self.isLoading = false
    }
    func createCommunityMediate() {
        
    }
    func createCommunity(email: String, password: String, completion: @escaping(validationResponses, _ error: Error?) -> (Void)) -> validationResponses {
        let createCommunityRequestJSON = BasicWithInfoJSONModel(authentication_key: "_", request: "create", info: user.PersonID)
        guard let createCommunityRequestJSONData = try? JSONEncoder().encode(createCommunityRequestJSON) else { return .error }
        firstly {
            query.Request(urlString: query.db.URLs["createCommunityURL"] ?? "", jsonData: createCommunityRequestJSONData, responseFormat: .basic)
        }.done { (response : HTTPResponse) in
            guard let convertedResponse = (response as? BasicHTTPResponse) else { throw RuntimeError("Server Failed to Respond")}
            let verdict : validationResponses = {
                switch(convertedResponse.result){
                    case "account_created": return .success
                    case "account_exists" : return .customResponse1
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
