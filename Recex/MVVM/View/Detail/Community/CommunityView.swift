import SwiftUI
import MobileCoreServices

struct CommunityView: View {
    // For Dark Mode Adoption....
    @Environment(\.colorScheme) var scheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    @ObservedObject var model : CommunityViewModel = CommunityViewModel(community: Community(id: "", userIsIn: false, isPublic: false, joinCode: "", name: "", description: "", image: UIImage(), participants: 0, chiefCook: "", notifications: 0))
    
    init(community : Community) {
        self.model.community = community
    }
    
    var body: some View {
        
//        model.bg
//            .edgesIgnoringSafeArea(.all)
        
            ScrollView(.vertical, showsIndicators: false){
                // Since Were Pinning Header View
                LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [.sectionHeaders], content: {
                    // Parallax Header....
                    GeometryReader{reader -> AnyView in
                        
                        let offset = reader.frame(in: .global).minY
                        
                        if -offset >= 0{
                            DispatchQueue.main.async {
                                self.model.offset = -offset
                            }
                        }
                        
                        return AnyView(
                            
                            Image(uiImage: self.model.community.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 250 + (offset > 0 ? offset : 0))
                                .cornerRadius(2)
                                .offset(y: (offset > 0 ? -offset : 0))
                                .overlay(
                                    HStack{
                                        Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                                            Image(systemName: "arrow.left")
                                                .font(.system(size: 30, weight: .bold))
                                                .foregroundColor(.white)
                                        })
                                        .padding()
                                        Spacer()
                                    }
                                    .padding(),
                                    alignment: .top
                                )
                        )
                    }
                    .frame(height: 250)
                    // Posts
                    Section(header: CommunityHeaderView(community: $model.community).padding([.trailing])) {
                        if(model.loading) { InBuiltLoadingView(animation: true, size: 125)}
                        else {
                            ForEach(model.posts) { recipe in
                                RecipePost(recipe: recipe)
                                    
                            }
                            .padding()
                        }
                        
                    }
                })
            }
            .overlay(
                (scheme == .dark ? Color.black : Color.white)
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .ignoresSafeArea(.all, edges: .top)
                    .opacity(model.offset > 250 ? 1 : 0)
                ,alignment: .top
            )
            .edgesIgnoringSafeArea(.all)
            // Used It Environment Object For Accessing All Sub Objects....
            .environmentObject(model)
            .frame(height: UIScreen.main.bounds.height)
            
            BottomSheetView(isOpen: $model.inviteSheetOpen, maxHeight: 250, minHeightRatio: 0) {
                VStack(spacing: 10) {
                    Text("Choose How To Invite")
                        .font(.title)
                    Text("Join Code: \(model.community.joinCode)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("ColorThemeMain"))
                    
                    Divider()
                    
                    Button(action: {
                        UIPasteboard.general.setValue(model.community.joinLink,
                                   forPasteboardType: kUTTypePlainText as String)
                        self.model.inviteSheetOpen.toggle()
                    }, label: {
                        Text("Copy Link")
                            .padding([.top, .bottom], 8)
                            .padding([.trailing, .leading], 15)
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                    
                    
                    Button(action: {
                        self.model.inviteSheetOpen.toggle()
                        self.model.openQRCode.toggle()
                        
                    }, label: {
                        Text("QR Code")
                            .padding([.top, .bottom], 8)
                            .padding([.trailing, .leading], 15)
                            .frame(width: UIScreen.main.bounds.width - 40)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    })
                }
                
            }.edgesIgnoringSafeArea(.all)
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .sheet(isPresented: $model.openQRCode, content: {
                InviteFriends(community: self.model.community)
            })
    }
}
struct CommunityHeaderView: View {
    
    @EnvironmentObject var model : CommunityViewModel
    @Environment(\.colorScheme) var scheme
    
    @Binding var community : Community
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        VStack(alignment: (model.offset > 250) ? .leading : .center, spacing: 0){
            
            HStack(spacing: 0){
                Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 28, weight: .bold))
                        .frame(width: getSize(), height: getSize())
                        .foregroundColor(.primary)
                })
                .padding([.top], 30)
                .padding(.bottom, 15)
                
                
                Text(community.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding([.top], 30)
                    .padding(.bottom, 15)
                    .padding(.trailing)
                
                if(model.offset > 250){
                    Spacer()
                }
            }
            .background(model.offset <= 250 ? Color.clear : scheme == .dark ? Color.black : Color.white)
            .padding([.top, .trailing])
            
            
            if model.offset > 250{
                Divider()
            } else {
                ZStack{
                    VStack(alignment: .center, spacing: 10, content: {
                        Text(community.description)
                            .font(.callout)
                        
                        HStack(spacing: 8){
                            Text("\(community.participants) Members • " + (community.isPublic ? "Public Community" : "Private Community" ))
                        }
                        HStack (spacing: -10) {
                            ForEach(model.colors, id: \.self) { color in
                                color
                                    .frame(width: 40, height: 40)
                                    .offset()
                                    .clipShape(Circle())
                            }
                            Button(action: { model.inviteSheetOpen.toggle() }, label: {
                                Text("+ Invite")
                                    .fontWeight(.bold)
                                    .padding([.top, .bottom], 8)
                                    .padding([.leading, .trailing], 15)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            })
                            .offset(x: 20)
                            
                        }
                        .padding([.trailing])
                        
                        Divider()
                        
                        HStack {
                            Button(action:{}, label: {
                                
                                Image(systemName: "")
                                
                                Text("Create Post")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding([.top, .bottom], 8)
                                    .padding([.leading, .trailing], 15)
                                    .frame(width: UIScreen.main.bounds.width / 2 - 20)
                                    .background(Color("ColorThemeMain"))
                                    .cornerRadius(10)
                            })
                            
                            Button(action: {}, label: {
                                Text("Ask for Inspiration")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding([.top, .bottom], 8)
                                    .padding([.leading, .trailing], 15)
                                    .frame(width: UIScreen.main.bounds.width / 2 - 20)
                                    .background(Color("ColorThemeMain"))
                                    .cornerRadius(10)
                            })
                        }
                        .padding([.trailing])
                        
                        Divider()
                    })
                    .opacity(model.offset > 200 ? 1 - Double((model.offset - 200) / 50) : 1)
                    .padding(.trailing)
                    
                }
                .frame(height: 150)
                .padding(.trailing)
                
                
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.trailing)
        .frame(height:  200)
        .background(model.offset > 250 ? Color.clear : scheme == .dark ? Color.black : Color.white)
    }
    
    // Getting Size Of Button And Doing ANimation...
    func getSize()->CGFloat{
        
        if model.offset > 200{
            let progress = (model.offset - 200) / 50
            
            if progress <= 1.0{
                return progress * 40
            }
            else{
                return 40
            }
        }
        else{
            return 0
        }
    }
}
