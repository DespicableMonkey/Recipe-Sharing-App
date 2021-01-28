//
//  FinishSignUpView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/27/21.
//

import SwiftUI

struct FinishSignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var model = FinishSigningUpViewModel()
    var body: some View {
        
            ScrollView {
                VStack {
                    
                    HStack {
                        Text("You're\nalmost\nthere!")
                            .fontWeight(.bold)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                            .padding()
                            .onReceive(model.viewDismissalModePublisher) { shouldDismiss in
                                if shouldDismiss {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        Spacer()
                    }
                    
                    HStack {
                        Text("Just a few more questions, and then you can get right to cooking a variety of recipes with thousands of other people!")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    
                    VStack {
                        ZStack {
                            Image(uiImage: ((self.model.profileImage != UIImage()) ? self.model.profileImage : UIImage(named: "CameraAddIcon"))!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .cornerRadius(100)
                                .overlay(
                                            RoundedRectangle(cornerRadius: 100)
                                                .stroke(Color.black, lineWidth: 3)
                                        )
                        }
                        .sheet(isPresented: $model.imgPicker, content: {
                            ImagePickerView(isPresented: $model.imgPicker, image: $model.profileImage)
                        })
                        .onTapGesture {
                            model.imgPicker.toggle()
                        }
                        
                        
                        if(model.profileImage == UIImage()) {
                            Text("Profile Picture(Optional)")
                                .font(.callout)
                        }
                        
                        if(model.alertText.count > 0) {
                            Text(model.alertText)
                                .foregroundColor(Color.red)
                                .padding(.top, 10)
                        }
                        
                        CustomTextField_V3(placeholder: "", target: "Username", limit: 16, txt: $model.username)
                            .padding(.top, 10)
                        CustomTextField_V3(placeholder: "Optional", target: "Brief Description", limit: 100, txt: $model.description)
                            .padding(.bottom, 25)
                        
                        Button(action:{self.model.finish()}, label: {
                            Text("Finish")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.title3)
                                .padding([.top, .bottom], 10)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                                
                        })
                        .background(Color("ColorThemeMain"))
                        .cornerRadius(10)
                        .padding([.leading, .trailing], 30)
                       
                            
                    }
                   
                    .padding([.top, .bottom], 40)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                   
                Spacer()
                    
                }
                .padding()
            }
            .background(Color.orange.edgesIgnoringSafeArea(.all))
        
    }
}

