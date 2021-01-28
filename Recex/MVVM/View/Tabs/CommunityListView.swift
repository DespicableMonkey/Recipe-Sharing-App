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
                ZStack{
                    if(model.communities.count == 0) {
                        NoCommunitiesListView(createCommunityIsPresented: self.$createCommunityIsPresented)
                    } else {
                        ScrollView(.vertical, showsIndicators: false, content: {
                            VStack {
                                ForEach(model.communities) {community in
                                    NavigationLink(destination: CommunityView(community: community)) {
                                        CommunityListResultView(community: community)
                                    }
                                   // if(index != model.communities.count - 1) {
                                        Divider()
                                            .padding([.leading, .trailing])
                                            .padding([.top], 10)
                                   // }
                                }.padding()
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
                                
                                Button(action: {
                                    withAnimation() {
                                        self.model.joinCommunityModal.toggle()
                                    }
                                }) {
                                    VStack {
                                        Text("Join A Community")
                                            .foregroundColor(Color.white)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding()
                                    }
                                    .background(Color("ColorThemeMain"))
                                    .cornerRadius(15)
                                    .sheet(isPresented: self.$createCommunityIsPresented, content: { CreateCommunityView()})
                                }
                                
                                Spacer()
                            }
                        })
                        
                    }
                
                    if(self.model.joinCommunityModal) {
                        BottomSheetView(isOpen: $model.joinCommunityModal, maxHeight: 450, minHeightRatio: 0) {
                        if(model.joinLoading) {
                            InBuiltLoadingView(animation: true, size: 75)
                        } else {
                        VStack(spacing: 10) {
                            Text("Join a Community")
                                .font(.title)
                            CustomTextField_V3(placeholder: "e.g. H78HD62K", target: "Enter Community Join Code", limit: 8, txt: self.$model.joinTxt)
                            Button(action: {
                                self.model.joinCommunity()
                            }, label: {
                                Text("Join")
                                    .padding([.top, .bottom], 8)
                                    .padding([.trailing, .leading], 15)
                                    .frame(width: UIScreen.main.bounds.width - 40)
                                    .foregroundColor(Color.white)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            })
                            
                            if(model.joinCodeError.count > 0) {
                                Text(model.joinCodeError)
                                    .foregroundColor(Color.red)
                                    .padding()
                            }
                            
                            
                            

                            Divider()
                                                
                            
                            HStack{
                                Text("If you do not have a join code, you can scan a QR code or use a link given to you by a member within the community. If the community is public you can also join it by searching for the community in the Explore Tab.")
                                    .padding()
                                Spacer()
                            }
                        }
                        }
                        
                        } .edgesIgnoringSafeArea(.all)
                        .allowsHitTesting(model.joinCommunityModal ? true : false)
                    }
                
                }
                
            }
        
//        .sheet(isPresented: $model.openQRCode, content: {
//            InviteFriends(community: self.model.community)
//        })
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
    @ObservedObject var community : Community
    
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
