//
//  CommunityViewModel.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/23/21.
//

import Foundation

import SwiftUI

class CommunityViewModel: ObservableObject {
    @Published var offset: CGFloat = 0
    @Published var posts : [Recipe] = [Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false), Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false), Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false), Recipe(image: nil, title: "Lava Cake", detail: "Easy to Bake", upvotes: 5, type: "none", color: Color.red, time: 39, timeUnit: "Minutes", creator: "Seld", creatorImage: nil, createdByUser: true, creation: "4 Days Ago", expand: false)]
    @Published var community : Community
    @Published var colors = [Color.black, Color.blue, Color.orange, Color.yellow, Color.red, Color.purple, Color.pink, Color.gray, Color.primary, Color.green]
    @Published var inviteSheetOpen : Bool = false
    
    var bg : Color = Color.gray.opacity(0.1)
    
    init(community : Community) {
        self.community = community
    }
}
