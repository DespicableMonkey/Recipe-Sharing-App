//
//  Data.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import Foundation
import CommonCrypto

extension Data {
    var hexString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
    var sha256: Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        self.withUnsafeBytes({
            _ = CC_SHA256($0, CC_LONG(self.count), &digest)
        })
        return Data(digest)
    }
}
