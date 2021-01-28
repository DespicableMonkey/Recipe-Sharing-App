//
//  CommunityListViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/17/21.
//

import Foundation
import UIKit
import PromiseKit
import SPAlert

class CommunityListViewModel : ObservableObject {
    
    @Published var user : User = .shared
    @Published var communities : [Community]
    @Published var joinTxt : String = ""
    @Published var joinCodeError : String = ""
    @Published var joinLoading : Bool = false
    @Published var joinCommunityModal = false
    
     ///make an object of the query class to send queries to server
    var query = Query()
    
    init() {
        //fetch the communities
        fetchCommunities()
    }
    /**
     Fetch Each Communities Image using the primary key stored for each community when the user's data is fetched
     */
    func fetchCommunities() {
        //clear communities so append function doesnt duplicate them
        communities = []
        //index to tell the program which community to give the image to
        var location = 0
        //loop through all communities
        for (id, community) in user.Communities {
            //Append each community to the array(without the image)
            self.communities.append(Community(id: id.replacingOccurrences(of: "Community-", with: "", options: .literal, range: nil), userIsIn: true, isPublic: true, joinCode: community["Community_Join_Code"] ?? "", name: community["Community_Title"] ?? "", description: community["Community_Description"] ?? "", image: UIImage(), participants: 1, chiefCook: "", notifications: 0))
            //fetch the image, and set it to the community once its fetched
            let url = ("https://recex.applications.pulkith.com/mobile/communities/fetchImage") + ("?authentication_key=ak&request=FetchImage&url=") + (community["Community_Image"] ?? "")
            Images.fetchImage(from: url, data: "",dataIndex: location, completion: { image, void, index  in
                self.communities[index!].image = (image ?? UIImage(named: "TestImage1")!)
            })
            location += 1
        }
    }
    /**
     Join a Community with the given join code
     
     */
    func joinCommunity() {
        //text that tells the user about any errors in their input or in the query
        joinCodeError = ""
        
        //all join codes are 8 characters long
        if(joinTxt.count != 8) {
            joinCodeError = "Invalid Join Code"
            return
        }
        
        //make the loading view
        self.joinLoading = true
        //call function to request to join the community
        let _ = queryJoinCommunity(completion: {
            (response, error) in
            //stop loading view
            self.joinLoading = false
            if(error != nil ) {
               //error occured
            } else {
                //community was successfully joined
                if(response == .success) {
                    //alert that community joined
                    SPAlert.present(title: "Community Joined", preset: .done)
                    //close the modal
                    self.joinCommunityModal.toggle()
                    
                    //refetch communities
                    self.user.fetchDataWithCompletion {
                        self.fetchCommunities()
                    }
                }
                //errors occured such as user already in community or the code does not exist
                else if(response == .customResponse1) { self.joinCodeError = "You are already in this community"}
                else if(response == .customResponse2) { self.joinCodeError = "Invalid Join Code"}
                
                
            }
        })

    }
    /**
     Query the request to join a community
     - Parameters:
        - completion: completion handler after response or error is received
        
     - Returns:
        - validationResponses: a response as to wether the query was successfully executed
     */
    func queryJoinCommunity(completion: @escaping(validationResponses, _ error: Error?) -> (Void)) -> validationResponses {
        //create dictionary and enter in all the values
        var dict : [String: String] = [:]
        dict["user_key"] = user.PersonID
        dict["community_code"] = joinTxt
        
        //create json
        let json = BasicWithDictJSONModel(authentication_key: "-", request: "join", data: dict)
        //convert json to data
        guard let jsonData = try? JSONEncoder().encode(json) else { return .error }
        firstly {
            //send the request with the data
            query.Request(urlString: "https://recex.applications.pulkith.com/mobile/communities/join", jsonData: jsonData, jsonModel: BasicWithDictJSONModel.self, responseFormat: .basic)
        }.done { (response : HTTPResponse) in
            //convert the reponse to the format expected
            guard let convertedResponse = (response as? BasicHTTPResponse) else { throw RuntimeError("Server Failed to Respond")}
            //return a validationResponse based on the response from the server
            let verdict : validationResponses = {
                switch(convertedResponse.result){
                    case "community_joined": return .success
                    case "err_already_in_community": return .customResponse1
                    case "err_community_not_found": return .customResponse2
                    case "error" : return .error
                    default: return .error
                }
            }()
            completion(verdict, nil)
        }.catch { (error : Error) in
            // an error occured, so send it back to the handler
            switch (error){
                case is RuntimeError: completion(.error, error)
                default: completion(.error, RuntimeError("Something Unknown Happened"))
            }
        }
        //successful query occured
        return validationResponses.none
    }

    
    
//    func fetchCommunity(id: String, completion: @escaping(Community, _ error: Error?) -> (Void)) -> validationResponses {
//        let fetchCommunityJSON = BasicWithInfoJSONModel(authentication_key: "-", request: "fetchCommunity", info: user.PersonID)
//        guard let fetchCommunityJSONData = try? JSONEncoder().encode(fetchCommunityJSON) else { return .error }
//
//        firstly {
//            query.Request(urlString: Database.URLs["fetchCommunityDataURL"], jsonData: fetchCommunityJSONData, responseFormat: <#T##responseFormats#>)
//        }
//
//
//    }
}
