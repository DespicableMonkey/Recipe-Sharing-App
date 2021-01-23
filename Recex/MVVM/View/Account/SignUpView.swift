//
//  SignUpView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import SwiftUI
import CoreData
import CommonCrypto
import PromiseKit


struct SignUpView : View {
    /*
     
     Add x Mark / Back Button Instead of Having a "Already Have An Account?" Button
     */
    @StateObject var  model : ModelData
    
    var body : some View  {
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
                        .animation(.easeInOut(duration: 0.5))
                    Text("Ex")
                        .font(.system(size: 65, weight: .heavy))
                        .foregroundColor(.red)
                        .animation(.easeInOut(duration: 0.5))
                }
                .padding(.bottom, 0)
                .padding(.top, -20)
                Text("New Account")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundColor(Color("ColorThemeMain"))
                    
                    .multilineTextAlignment(.center)
                if(model.alert != nil && model.alert?.length ?? 0 > 0){
                    Text(model.alert ?? "")
                        .font(.system(size: 20))
                        .foregroundColor(Color.red)
                        .multilineTextAlignment(.center)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                }
            }
            .padding(.bottom, 25)
            .animation(.easeInOut(duration: 0.5))
            
            
            VStack{
                CustomTextField(image: "person", placeholder: "Email", txt: $model.email_SignUp)
                CustomTextField(image: "lock", placeholder: "Password", txt: $model.password_SignUp)
                CustomTextField(image: "lock", placeholder: "Re-Enter Password1", txt: $model.reEnterPassword)
            }
            .padding(.bottom, 25)
            Button(action: model.signUp, label: {
                Text("Sign Up")
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
                
                Text("Already Have An Account?")
                    .foregroundColor(Color.gray.opacity(0.9))
                
                Button(action: {model.isSignUp.toggle(); model.alert = nil}, label: {
                    Text("Login here")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color("ColorThemeMain"))
                })
            }
            .padding(.bottom, 170)
        }
    }
    
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView(model: model)
//    }
//}
