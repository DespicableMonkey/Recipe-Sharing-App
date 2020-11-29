//
//  QRGenerator.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

import Foundation
import SwiftUI

struct QRGenerator {
    var data : String
    
    func Generate() -> Data? {
        guard let filter = CIFilter(name : "CIQRCodeGenerator") else { return nil }
        let transcodedData = data.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(transcodedData, forKey: "inputMessage")
        guard let image = filter.outputImage else { return nil }
        let imageAsUIImage = UIImage(ciImage: image)
        return imageAsUIImage.pngData()
    }
}
