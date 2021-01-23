//
//  CommunityListViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/17/21.
//

import Foundation
import UIKit
import PromiseKit

class CommunityListViewModel : ObservableObject {
    @Published var user : User = .shared
    @Published var communities : [Community]
    var query = Query()
    init() {
        communities = []
        print(communities)
        for (id, community) in user.Communities {
            let url = ("https://recex.applications.pulkith.com/mobile/communities/fetchImage") + ("?authentication_key=ak&request=FetchImage&url=") + (community["Community_Image"] ?? "")
                Images.fetchImage(from: url, completion: { image in
                self.communities.append(Community(id: id.replacingOccurrences(of: "Community-", with: "", options: .literal, range: nil), userIsIn: true, isPublic: true, joinCode: community["Community_Join_Code"] ?? "", joinLink: "", name: community["Community_Title"] ?? "", description: community["Community_Description"] ?? "", image: image!, participants: 1, chiefCook: "", notifications: 0))
            })
        }
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
