//
//  NavigationView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/27/20.
//

import SwiftUI
import SPAlert

//
//  NavigationViews.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/26/20.
//

import SwiftUI

var tabItemIcons : [Image] = [Image("HomeIcon"), Image("SearchIcon"), Image("CommunityIcon"), Image("ChefIcon"), Image("ProfileIcon")]
var tabItems = ["Home", "Explore", "Communities", "Pantry", "Profile"]

struct NavigationController: View {
    
    @ObservedObject var user: User = .shared
    
    @State var dark = false
    @State var show = false
    @State var selected = "Home"
    @State var hold = true
    
    @State var PresentNewRecipe = false
    @State var logout = false
    @State var openMoreInfo = false
    
    init(){
        user_cons.PersonID = AS.retrieve(for: "PersonID") as! String
        user = User(PersonID: user_cons.PersonID)
        UITabBar.appearance().isHidden = true
        
    }

    //                .onTapGesture {
    //                    if(show == true) { self.show.toggle() }
    //                }
    
    @State var centerX : CGFloat = 0
    var body: some View {
        NavigationView {
            if(self.logout) {
                LoginView()
            } else {
                    ZStack{
                        VStack (spacing : 0){

                            VStack {
                                ZStack {
                                    HStack {
                                        Button(action: {
                                            withAnimation(.default){
                                                self.show.toggle()
                                            }
                                        }) {
                                            Image("MenuIcon")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                        }
                                        .onAppear() {
                                            if(!((AS.retrieve(for: "FinishedSignUp") as? Bool)!)) {
                                                self.openMoreInfo = true
                                            }
                                        }
                                        .fullScreenCover(isPresented: self.$openMoreInfo, content: {
                                            FinishSignUpView()
                                        })
                                        Spacer()
                                    }
                                    Text("\(selected)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color("ColorThemeMain"))
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            self.PresentNewRecipe.toggle()
                                        }) {
                                            Image(systemName: "plus.square")
                                                .resizable()
                                                .frame(width:25, height: 25)
                                                .fullScreenCover(isPresented: self.$PresentNewRecipe){
                                                    CreateRecipeView()
                                                }
                                        }
                                        
                                    }
                                    
                                }
                                .padding()
                                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 0 : 15)
                                .padding(.bottom)
                                .foregroundColor(.primary)
                                .overlay(Rectangle().stroke(Color.primary.opacity(0.1), lineWidth: 1).shadow(radius: 3).edgesIgnoringSafeArea(.top))
                                //background(Color("ColorThemeMain"))
                                
                                
                            }
                            .padding(.bottom)
                            
                            
                            TabView(selection: $selected){
                                HomeView()
                                    .tag(tabItems[0])
                                    .ignoresSafeArea(.all, edges: .top)
                                    .navigationBarTitle("") //this must be empty
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                ExploreView()
                                    .tag(tabItems[1])
                                    .ignoresSafeArea(.all, edges: .top)
                                    .navigationBarTitle("") //this must be empty
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                CommunityListView()
                                    .tag(tabItems[2])
                                    .ignoresSafeArea(.all, edges: .top)
                                    .navigationBarTitle("") //this must be empty
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                PantryView()
                                    .tag(tabItems[3])
                                    .ignoresSafeArea(.all, edges: .top)
                                    .navigationBarTitle("") //this must be empty
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                                Color.green
                                    .tag(tabItems[4])
                                    .ignoresSafeArea(.all, edges: .top)
                                    .navigationBarTitle("") //this must be empty
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)
                            }
                            .navigationBarTitle("") //this must be empty
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            
                            
                            HStack(spacing: 0){
                                
                                ForEach(tabItems,id: \.self){value in
                                    
                                    GeometryReader{reader in
                                        
                                        TabBarButton(selected: $selected, value: value, image: tabItemIcons[tabItems.firstIndex(of: value) ?? 0], centerX: $centerX, rect: reader.frame(in: .global))
                                            // setting First Intial Curve...
                                            .onAppear(perform: {
                                                
                                                if value == tabItems.first{
                                                    centerX = reader.frame(in: .global).midX
                                                }
                                            })
                                    }
                                    .frame(width: 70, height: 50)
                                    
                                    if value != tabItems.last{Spacer(minLength: 0)}
                                }
                            }
                            .padding(.horizontal,25)
                            .padding(.top) // For Smaller Size iPhone Padding Will be 15 And For Notch Phones No Padding
                            .padding(.bottom,UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : 30)
                            .background(Color.white.clipShape(AnimatedShape(centerX: centerX)))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
                            
                            
                            
                            
                        }
                        .padding(.vertical)
                        HStack {
                            Menu(dark: self.$dark, show: self.$show, logout: self.$logout)
                                .preferredColorScheme(self.dark ? .dark : .light)
                                .offset(x: self.show ? 0 : -UIScreen.main.bounds.width / 1.5)
                            
                            Spacer(minLength: 0)
                            
                        }
                        .edgesIgnoringSafeArea([.top, .bottom])
                        .background(Color.primary.opacity(self.show ? (self.dark ? 0.05 : 0.2) : 0).edgesIgnoringSafeArea(.all))
                        .padding(.vertical)
                        
                    }
                    .padding(.vertical)
                    
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
struct NavigationController_Previews: PreviewProvider {
    static var previews: some View {
        NavigationController()
            .previewDevice("iPhone 12 Pro Max")
    }
}
struct TabBarButton : View {
    
    @Binding var selected : String
    var value: String
    var image : Image
    @Binding var centerX : CGFloat
    var rect : CGRect
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()){
                selected = value
                centerX = rect.midX
            }
        }, label :{
            
            VStack{
                image
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 26, height: 26)
                    .foregroundColor(selected == value  ? .purple : .gray)
                //.foregroundColor(selected == value ? Color("ColorThemeMain") : .gray)
                
                Text(value)
                    .font(.caption)
                    .foregroundColor(.black)
                    .opacity(selected == value ? 1 : 0)
                
            }
            .frame(width: 70, height: 50)
            .padding(.top)
            .offset(y: selected == value ? -15 : 0)
        })
    }
}

struct AnimatedShape : Shape {
    
    var centerX : CGFloat
    
    var animatableData: CGFloat {
        get { return centerX }
        set { centerX = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{ path in
            path.move(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 15))
            
            //Add the Curve
            
            path.move(to: CGPoint(x: centerX - 35, y: 15))
            
            path.addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x:centerX, y: -25))
        }
    }
}

struct Menu : View {
    
    @Binding var dark : Bool
    @Binding var show : Bool
    @Binding var logout : Bool
    
    @State var PresentInviteFriends  = false
    
    var body : some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Button(action: {
                        withAnimation(.default){
                            self.show.toggle()
                        }
                    }) {
                        Image("BackIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    Spacer()
                    
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title)
                    }
                    
                }
                .padding(.top, 50)
                .padding(.bottom, 25)
                
                Image("UserTestIcon")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                
                VStack(spacing: 12){
                    Text("Pulkith")
                    
                    Text("Developer")
                        .font(.caption)
                    
                }
                .padding(.top, 25)
                .padding(.bottom, 25)
                
                HStack (spacing: 25){
                    Image(systemName: "moon.fill")
                        .font(.title)
                    Text("Dark Mode")
                    Spacer()
                    
                    Button(action: {
                        self.dark.toggle()
                        
                        UIApplication.shared.windows.first?.rootViewController?.view.overrideUserInterfaceStyle = self.dark ? .dark : .light
                    }) {
                        Image("OffIcon")
                            .font(.title)
                            .rotationEffect(.init(degrees: self.dark ? 180 : 0))
                        
                    }
                }
                
                Group {
                    Button(action : {
                        self.PresentInviteFriends = true
                        
                    }) {
                        HStack (spacing : 22){
                                Image("HelpIcon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                                
                                Text("Help")
                                    .font(.system(size: 20))
                                Spacer()
                            Spacer()
                        }
                    }
                    .padding(.top, 25)
                    .fullScreenCover(isPresented: self.$PresentInviteFriends
                                     , content: { InviteFriends() })
                    Button(action : {
                        
                    }) {
                        HStack (spacing : 22){
                                Image("MediaIcon")
                                    .resizable()
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                                
                                Text("Media")
                                    .font(.system(size: 20))
                                Spacer()
                            Spacer()
                        }
                    }
                    .padding(.top, 25)
                    
                    Button(action : {
                        
                    }) {
                        HStack (spacing : 22){
                                Image("SettingsIcon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                                
                                Text("Settings")
                                    .font(.system(size: 20))
                                Spacer()
                            Spacer()
                        }
                    }
                    .padding(.top, 25)
                    
                    Button(action : {
                        
                    }) {
                        HStack (spacing : 22){
                                Image("NotificationIcon")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                                
                                Text("Notifications")
                                    .font(.system(size: 20))
                                Spacer()
                            Spacer()
                        }
                    }
                    .padding(.top, 25)
                    
                    Button(action : {
                        let ud = UserDefaults.standard
                        ud.setValue(false, forKey: "LoggedIn")
                        self.logout = true
                    }) {
                        HStack (spacing : 22){
                                Image(systemName: "arrow.left.to.line.alt")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding(.trailing, 10)
                                
                                Text("Logout")
                                    .font(.system(size: 20))
                                Spacer()
                            Spacer()
                        }
                    }
                    .padding(.top, 25)
                    
                    Divider()
                        .padding(.top, 25)
                }
                
                Spacer()
                
                VStack {
                    Text("Recex")
                        .font(.system(size: 30, weight: .bold))
                        .padding(.bottom, 20)
                        .foregroundColor(Color("ColorThemeMain"))
                    Text("Pulkith Paruchuri")
                        .font(.system(size: 18))
                        .padding(.bottom, 10)
                    Text("Version 1.0.0")
                        .font(.system(size: 13))
                    Text("Terms And Conditions")
                        .font(.system(size: 13))
                }
                .padding(.bottom, 75)
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.height)
        .background(self.dark ? Color.black : Color.white).edgesIgnoringSafeArea(.all)
        .overlay(Rectangle().stroke(Color.primary.opacity(0.2), lineWidth: 2).shadow(radius: 3).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea([.top, .bottom])
    }
}
