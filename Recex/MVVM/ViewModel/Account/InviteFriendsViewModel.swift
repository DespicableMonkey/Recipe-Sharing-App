//
//  InviteFriendsViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

import Foundation
import SwiftUI

class InviteFriendsViewModel : ObservableObject{
    @ObservedObject var user: User = .shared
    
     var ShareableLink : String = ""
    @Published var QRImage : UIImage? = nil
    @Published var copied = false
    
    init(){
        ShareableLink = generateShareableLink(uid_share: user.ShareIdentifier)
    }
    func generateQR() {
        let _ = generateFriendURL()
    }
    
    func generateShareableLink(uid_share : String ) -> String { return "https://recex.applications.pulkith.com/mobile/invite?uid_share=\(uid_share)&request=mobile&type=QR&response=none" }
    
    func generateFriendURL() {
    let result = QRGenerator(data: ShareableLink).Generate()
        if(result != nil){
            guard let image = UIImage(data: result!) else { return }
            QRImage = image
        }
    }
    func RemoveCopied(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.copied = false
        }
    }
    
}
