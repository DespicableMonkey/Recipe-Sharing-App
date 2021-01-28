//
//  LoginView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import SwiftUI
import CoreData
import CommonCrypto
import PromiseKit

struct LoginView: View {
    //@Environment(\.managedObjectContext) private var viewContext
    
    @StateObject var model = ModelData()
    var body: some View {
            if(((UserDefaults.standard.bool(forKey: "LoggedIn") == true || model.loggedIn))){
                NavigationController()
            }
            else{
                ZStack {
                    VStack {
                        Image("LoginBackgroundSecondary").resizable()
                            .padding(.top, -70)
                            .background(Color.white.opacity(1.0))
                            .scaledToFit()
                            .frame(height: 400)
                            .padding(.leading, 0)
                        
                        
                        VStack{
                            
                            HStack(spacing: 0) {
                                Text("Rec")
                                    .font(.system(size: 65, weight: .heavy))
                                    .foregroundColor(.yellow)
                                Text("Ex")
                                    .font(.system(size: 65, weight: .heavy))
                                    .foregroundColor(.red)
                            }
                            .padding(.bottom, 0)
                            .padding(.top, -20)
                            Text("Login")
                                .font(.system(size: 26, weight: .heavy))
                                .foregroundColor(Color("ColorThemeMain"))
                            
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                            if(model.alert != nil && model.alert?.length ?? 0 > 0){
                                Text(model.alert ?? "")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.red)
                                    .multilineTextAlignment(.center)
                                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                            }
                        }
                        .padding(.bottom, 0)
                        
                        
                        VStack{
                            CustomTextField(image: "person", placeholder: "Email", txt: $model.email)
                            CustomTextField(image: "lock", placeholder: "Password", txt: $model.password)
                        }
                        .padding(.bottom, 25)
                        
                        Button(action: model.login, label: {
                            Text("Login")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 30)
                                .background(Color("ColorThemeMain"))
                                .clipShape(Capsule())
                                .shadow(color: Color.black.opacity(0.4), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                        })
                        .padding(.bottom, 15)
                        
                        HStack{
                            
                            Text("Don't have an Account?")
                                .foregroundColor(Color.gray.opacity(0.9))
                            
                            Button(action: {model.isSignUp.toggle(); model.alert = nil}, label: {
                                Text("Sign Up Now")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color("ColorThemeMain"))
                            })
                        }
                        .padding(.bottom, 20)
                        
                        Button(action: model.forgotPassword, label: {
                            Text("Forgot Password?")
                                .fontWeight(.bold)
                                .foregroundColor(Color("ColorThemeMain"))
                        })
                        .padding(.bottom, 105)
                        
                    }
                    
                    if model.isLoading {
                        LoadingView()
                    }
                }
                .background(Color(hex: 0xffffff)).ignoresSafeArea(.all, edges: .all)
                .navigationBarHidden(true)
                .navigationTitle("")
                .fullScreenCover(isPresented: $model.isSignUp) {
                    SignUpView(model: model)
                }
            }
        }
}

struct CustomTextField : View {
    var image : String
    var placeholder : String
    @Binding var txt : String
    
    var body : some View{
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
            Image(systemName: image)
                .font(.system(size: 24))
                .foregroundColor(Color.white)
                .frame(width: 60, height: 60)
                .background(Color("ColorThemeMain"))
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            
            ZStack{
                if placeholder == "Password" || placeholder == "Re-Enter Password" {
                    SecureField(placeholder, text: $txt)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                }
                else {
                    TextField(placeholder, text: $txt)
                }
            }
            .padding(.horizontal)
            .padding(.leading, 65)
            .frame(height: 60)
            .clipShape(Capsule())
            Divider()
                .frame(height: 1)
                .padding(.horizontal)
                .background(Color.black.opacity(0.2))
                .padding(.leading, 81)
                .padding(.top, 30)
                .padding(.trailing, 20)
            
        }
        .padding(.horizontal)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
