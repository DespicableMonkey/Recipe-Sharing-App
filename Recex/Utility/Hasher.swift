//
//  Hasher.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/26/20.
//

import Foundation
import SwiftUI
import CommonCrypto

struct Hasher {
    func Hash(key : String, genSalt : Bool, salt: String? = nil) -> [String]{
        
        guard let createdSalt = ( (!genSalt) ? salt: generateCSPRNG()) else { return ["err_nil_salt"] }
        
        if(createdSalt == "error"){ return ["error"] }
        let hash = key.sha256(salt: createdSalt).hexString
        
        return [hash, createdSalt]
    }
    func sha256(data : Data) -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    func generateCSPRNG() -> String? {
        var keyData = Data(count: 32)
        let result = keyData.withUnsafeMutableBytes {
            (mutableBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
            SecRandomCopyBytes(kSecRandomDefault, 32, mutableBytes)
        }
        
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            return "error"
        }
    }
}
