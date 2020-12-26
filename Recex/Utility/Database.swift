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
        "verifyConnectionIntegrity" : "http://recex.applications.pulkith.com/services/cross-check",
        "connectionTestURL" : "http://recex.applications.pulkith.com/sercices/attempt-connection",
        "authenticationURL" : "http://recex.applications.pulkith.com/account/mobile/services/authentication",
        "selectDataURL" : "http://recex.applications.pulkith.com/account/mobile/services/select",
        "updateDataURL" : "http://recex.applications.pulkith.com/account/mobile/services/update",
        "insertDataURL" : "http://recex.applications.pulkith.com/account/mobile/services/insert",
        
        "public_api-ingredientsURL" : "http://recex.applications.pulkith.com/mobile/public_api/resources?request=ingredients-master"
                    ]
    var Account : AccountModel
    
    init() {
        Account = AccountModel(urls: urlDict)
        let _ = configure()
    }
    
    func configure() -> Bool {
        return true
    }
    
}
