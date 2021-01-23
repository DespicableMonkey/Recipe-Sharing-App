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
        }
         self.isLoading = false
    }
    func createCommunityMediate() {
        let _ = createCommunity(completion: {
            (response, error) in
            if(error != nil ) {
                print(error?.localizedDescription)
                print("error")
            } else {
                self.user.fetchData()
                self.shouldPopView = true
            }
        })
        
    }
    func createCommunity(completion: @escaping(validationResponses, _ error: Error?) -> (Void)) -> validationResponses {
//        guard let imgData : Data = (self.communityImage.pngData()) else { return .error }
//        let imgString : String = String(decoding: imgData, as: UTF8.self)
        let createCommunityRequestJSON = BasicWithInfoFourJSONModel(authentication_key: "_", request: "create", info_one: self.communityName, info_two: self.communityDescription, info_three: "ImageUploadedAsMultipartForm", info_four: user.PersonID)
        guard let createCommunityRequestJSONData = try? JSONEncoder().encode(createCommunityRequestJSON) else { return .error }
        let imgData : [UIImage : String]
        firstly {
            query.RequestWithImage(urlString: Database.URLs["createCommunityURL"] ?? "", jsonData: createCommunityRequestJSONData, responseFormat: .basic, imageData: [self.communityImage: "CommunityImage"])
        }.done { (response : HTTPResponse) in
            guard let convertedResponse = (response as? BasicHTTPResponse) else { throw RuntimeError("Server Failed to Respond")}
            let verdict : validationResponses = {
                switch(convertedResponse.result){
                    case "community_created": return .success
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
