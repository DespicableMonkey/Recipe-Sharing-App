//
//  Community.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import Foundation
import UIKit
import SwiftUI

class Community : Identifiable, ObservableObject{
    
    /*
     Although this is a model, it conforms to observable object to allow each community list subview (3rd option on the tabbar) to observe this community, and update if the image of the community changes. This allows us to create the community list first, and then update each community's image as it comes from the server. 
     
     */
    
    //Primary Key of the Community
    @Published var id : String = ""
    //Whether the user is in this community or not
    @Published var userIsIn : Bool
    //Wheter the community is public
    @Published var isPublic : Bool
    //the join code for the community that goes into the community value in the link below
    @Published var joinCode : String = ""
    // the link given to share
    @Published var joinLink = "https://recex.applications.pulkith.com/mobile/communities/join?request=mobile&code="
    
    //the name of the community
    @Published var name : String = ""
    // the description of the community
    @Published var description : String = ""
    //an optional image for the community
    @Published var image : UIImage
    //the number of participants in the community
    @Published var participants : Int = 0
    //the creator/owner of the community who has the sole     ability to dissolve it and kick members
    @Published var chiefCook : String = ""
    
    @Published var notifications : Int = 0
    
    init(id: String, userIsIn: Bool, isPublic: Bool, joinCode: String, name: String, description: String, image: UIImage, participants: Int, chiefCook: String, notifications: Int) {
        self.id = id
        self.userIsIn = userIsIn
        self.isPublic = isPublic
        self.joinCode = joinCode
        self.name = name
        self.description = description
        self.image = image
        self.participants = participants
        self.chiefCook = chiefCook
        self.notifications = notifications
        self.joinLink = self.joinLink + self.joinCode
    }
}
