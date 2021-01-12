//
//  CommunityListView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import SwiftUI

struct CommunityListView: View {
    @ObservedObject var user: User = .shared
    @State var communities : [Community] = []
    init() {
        
    }
    
    var body: some View {
        VStack (spacing: 5){
            if(communities.count == 0) {
                NoCommunitiesListView()
            } else {
                
            }
        }
    }
}

struct CommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityListView()
    }
}

struct NoCommunitiesListView : View {
    @State var createCommunityIsPresented = false
    var body : some View {
        Image("CommunityIcon")
            .resizable()
            .frame(width: 100, height: 100)
        
       Text("You are not in any Communities")
        .font(.system(size: 25))
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        
        Text("You can search for a public community in the search tab, create a community, or join a private community using an invitation link. ")
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(Color.black.opacity(0.6))
        
        Button(action: {self.createCommunityIsPresented.toggle()}, label: {
            Text("Create A Community")
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding()
                
        }).background(Color("ColorThemeMain"))
        .cornerRadius(15)
        .sheet(isPresented: self.$createCommunityIsPresented, content: {
            CreateCommunityView()
        })
        
    }
}
