//
//  FetchImage.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/21/21.
//

import Foundation
import UIKit

final class Images {
    private init(){}
    
    static func fetchImage(from url: String, completion: @escaping(UIImage?) -> (Void)) -> (Void){
        guard let imageURL = URL(string: url) else { return }

            // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}
