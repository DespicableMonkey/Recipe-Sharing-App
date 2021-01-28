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


/// View Object for the Login View PAge
class CreateCommunityViewModel : ObservableObject {
    
    ///State Objects for the login view
    @Published var communityName = ""
    @Published var communityDescription = ""
    @Published var communityIsPublic = false
    
    @Published var descriptionTFHeight : CGFloat = 0
    
    @Published var isLoading = false
    
    @Published var alertTxt = ""
    
    @Published var communityImage : UIImage = UIImage()
    @Published var imagePickerIsPresented : Bool = false
    
    @Published var user : User = .shared
    
    ///Allows for dismiss of create community page programatically
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    private var shouldPopView = false {
        didSet {
            viewDismissalModePublisher.send(shouldPopView)
        }
    }
    
    ///make an object of the query class to send queries to server
    var query = Query()

    /**
     Create the community once the button is pressed, if all requirements are satisfied send the query to the server, otherwise tell the user what they are missing
     
     */
    func validateCreation() {
        self.alertTxt = ""
        if(communityName.trim().count < 3) {
            self.alertTxt = "Community Name must be at least 3 characters"
        } else if (communityDescription.trim().count < 1) {
            self.alertTxt = "Community Description cannot be blank"
        } else if (communityImage == UIImage()) {
            self.alertTxt = "Community must have an image"
        } else {
            //all requirements are satisfied
            self.createCommunityMediate()
        }
        
    }
    /// Function to house the completion handler after query is sent
    func createCommunityMediate() {
        self.isLoading = true
        //call query function
        let _ = createCommunity(completion: {
            (response, error) in
            self.isLoading = false
            if(error != nil ) {
            } else {
                //Community was sucessfully created
                //refetchData to get the community added
                self.user.fetchData()
                ///close the create community view
                self.shouldPopView = true
            }
        })
        
    }
    
    
    /**
     Returns a validationResponse as to wether the community was successfuly created
     
     - Parameters:
        - completion: called when the query is completed, or an error is throw
     - Returns:
        - validationResponses: wether the function successfuly queried the request
     */
    func createCommunity(completion: @escaping(validationResponses, _ error: Error?) -> (Void)) -> validationResponses {
//        guard let imgData : Data = (self.communityImage.pngData()) else { return .error }
//        let imgString : String = String(decoding: imgData, as: UTF8.self)
        let createCommunityRequestJSON = BasicWithInfoFourJSONModel(authentication_key: "_", request: "create", info_one: self.communityName, info_two: self.communityDescription, info_three: "ImageUploadedAsMultipartForm", info_four: user.PersonID)
        guard let createCommunityRequestJSONData = try? JSONEncoder().encode(createCommunityRequestJSON) else { return .error }
        firstly {
            query.RequestWithImage(urlString: Database.URLs["createCommunityURL"] ?? "", jsonData: createCommunityRequestJSONData, jsonModel: BasicWithInfoFourJSONModel.self, responseFormat: .basic, imageData: [self.communityImage: "CommunityImage"])
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
