//
//  Community.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import Foundation
import UIKit
import SwiftUI

struct Community : Identifiable{
    //Primary Key of the Community
    var id : String
    //Whether the user is in this community or not
    var userIsIn : Bool
    //Wheter the community is public
    var isPublic : Bool
    //the join code for the community that goes into the community value in the link below
    var joinCode : String
    // the link given to share
    var joinLink = "https://recex.applications.pulkith.com/mobile/communities/join?request=mobile&code="
    
    //the name of the community
    var name : String
    // the description of the community
    var description : String
    //an optional image for the community
    var image : UIImage
    //the number of participants in the community
    var participants : Int
    //the creator/owner of the community who has the sole     ability to dissolve it and kick members
    var chiefCook : String
    
    var notifications : Int
}
