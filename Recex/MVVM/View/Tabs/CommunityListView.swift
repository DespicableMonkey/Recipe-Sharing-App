//
//  CommunityListView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import SwiftUI

struct CommunityListView: View {
    @ObservedObject var user: User = .shared
    
    @State var createCommunityIsPresented = false
    @StateObject var model : CommunityListViewModel = CommunityListViewModel()
    
    var body: some View {
            VStack (spacing: 5){
                if(model.communities.count == 0) {
                    NoCommunitiesListView(createCommunityIsPresented: self.$createCommunityIsPresented)
                } else {
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack {
                            ForEach(0..<model.communities.count, id:\.self) {index in
                                NavigationLink(destination: CommunityView(community: model.communities[index])) {
                                    CommunityListResultView(community: model.communities[index])
                                }
                                if(index != model.communities.count - 1) {
                                    Divider()
                                        .padding([.leading, .trailing])
                                        .padding([.top], 10)
                                }
                            }
                            
                            Divider()
                                .padding()
                            
                            Button(action: {self.createCommunityIsPresented.toggle()}) {
                                VStack {
                                    Text("Create New Community")
                                        .foregroundColor(Color.white)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                                .background(Color("ColorThemeMain"))
                                .cornerRadius(15)
                            }
                            
                            Spacer()
                        }
                    })
                }
            }
            .sheet(isPresented: self.$createCommunityIsPresented, content: {
                CreateCommunityView()
            })
    }
}



struct NoCommunitiesListView : View {
    @Binding var createCommunityIsPresented : Bool
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
        
    }
}

struct CommunityListResultView : View {
    @State var community : Community
    var body : some View {
        VStack {
            HStack{
                Image(uiImage: community.image)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .scaledToFill()
                    .cornerRadius(50)
                    .padding([.top, .bottom], 5)
                    .padding(.leading, 5)
                
                VStack(alignment: .leading) {
                    Text(community.name)
                        .fontWeight(.bold)
                        .font(.title3)
                        .padding([.top, .leading], 10)
                    
                    Text("\(community.participants) cooks")
                        .foregroundColor(Color.black.opacity(0.75))
                        .padding(.leading, 10)
                    
                    
                    Spacer()
                }
                
                
                Spacer()
                
                if(community.notifications > 0) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("ColorThemeMain"))
                            .frame(width: 40, height: 40)
                        
                        
                        Text("\(community.notifications > 99 ? "99+" : "\(community.notifications)")")
                            .foregroundColor(.white)
                    }
                }
                
            }
            .cornerRadius(10)
            .frame(width: UIScreen.main.bounds.width - 20)
            .background(Color.black.opacity(0.02))
        }
        .frame(maxHeight: UIScreen.main.bounds.height / 14)
    }
}
