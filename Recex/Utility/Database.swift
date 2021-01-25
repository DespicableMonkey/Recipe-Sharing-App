//
//  Database.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
import CommonCrypto


struct Database {
    var urlDict = [
        "verifyConnectionIntegrity" : "https://recex.applications.pulkith.com/services/cross-check",
        "connectionTestURL" : "https://recex.applications.pulkith.com/sercices/attempt-connection",
        "authenticationURL" : "https://recex.applications.pulkith.com/account/mobile/services/authentication",
        "selectDataURL" : "https://recex.applications.pulkith.com/account/mobile/services/select",
        "updateDataURL" : "https://recex.applications.pulkith.com/account/mobile/services/update",
        "insertDataURL" : "https://recex.applications.pulkith.com/account/mobile/services/insert",
        
        "public_api-ingredientsURL" : "https://recex.applications.pulkith.com/mobile/public_api/resources?request=ingredients-master",
        
        "fetchUserDataURL" : "https://recex.applications.pulkith.com/account/mobile/services/fetch",
        
        "createCommunityURL" : "https://recex.applications.pulkith.com/mobile/communities/create",
        "fetchCommunityDataURL": "https://recex.applications.pulkith.com/mobile/communities/fetch",
        "fetchCommunityImageURL": "https://recex.applications.pulkith.com/mobile/communities/fetchImage",
        
        "publishRecipeURL" : "https://recex.applications.pulkith.com/mobile/recipes/publish"
                    ]
    
    static var URLs : [String: String] = [:]
    
    var Account : AccountModel
    
    init() {
        Account = AccountModel(urls: urlDict)
        Database.URLs = urlDict
        let _ = configure()
    }
    
    func configure() -> Bool {
        return true
    }
    
}
