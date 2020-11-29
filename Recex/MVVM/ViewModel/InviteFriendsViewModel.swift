//
//  InviteFriendsViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/28/20.
//

import Foundation
import SwiftUI

class InviteFriendsViewModel : ObservableObject{
    let User : User
    
    @Published var ShareableLink : String
    @Published var QRImage : UIImage? = nil
    @Published var copied = false
    
    init(user : User){
        self.User = user
        self.ShareableLink = "http://recex.applications.pulkith.com/mobile/invite?uid_share=\(User.ShareIdentifier)&request=mobile&type=QR&response=none"
        let _ = generateFriendURL()
    }
    
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
