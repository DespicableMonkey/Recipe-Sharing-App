//
//  CommunityViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/23/21.
//

import Foundation

import SwiftUI

class CommunityViewModel: ObservableObject {
    
    //Comunity Fields
    @Published var offset: CGFloat = 0
    @Published var posts : [Recipe] = [Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false), Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false), Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false), Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false)]
    @Published var community : Community
    @Published var colors = [Color.black, Color.blue, Color.orange, Color.yellow, Color.red, Color.purple, Color.pink, Color.green]
    @Published var inviteSheetOpen : Bool = false
    @Published var openQRCode : Bool = false
    
    @Published var loading  = true
    
    //backgeound Color
    var bg : Color = Color.gray.opacity(0.1)
    
    //setsthe community
    init(community : Community) {
        self.community = community
    }
}
