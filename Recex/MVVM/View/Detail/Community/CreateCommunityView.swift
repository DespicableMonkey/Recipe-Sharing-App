//
//  CreateCommunityView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/27/20.
//

import SwiftUI
import Foundation
import UIKit
import Combine

struct CreateCommunityView: View {
    @ObservedObject var user: User = .shared
    @ObservedObject var model  = CreateCommunityViewModel()
    @Environment(\.presentationMode) var presentationmode
    
    var body: some View {
        VStack {
            ZStack{
            VStack{
            HStack {

                
                Button(action: {self.presentationmode.wrappedValue.dismiss()}, label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .foregroundColor(Color.white.opacity(0.8))
                        .frame(width: 30, height: 30)
                })
                .padding()
                
                Text("Create a Community")
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .font(.system(size: 30))
                    .padding(.leading, 20)
                Spacer()
            }
            .background(Color("ColorThemeMain").edgesIgnoringSafeArea(.top))
            
            VStack {
               ZStack {
                if(model.communityImage != UIImage()) {
                    Image(uiImage: model.communityImage)
                        .resizable()
                        .frame(width: 150, height: 150)
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 3))
                        .clipped()
                } else {
                    Circle()
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color.gray.opacity(0.2))
                        
                    Image("CameraAddIcon")
                        .resizable()
                        .frame(width: 75, height: 75)
                }
               }
                .sheet(isPresented: $model.imagePickerIsPresented, content: {
                    ImagePickerView(isPresented: $model.imagePickerIsPresented, image: $model.communityImage)
                })
                .onTapGesture {
                    model.imagePickerIsPresented.toggle()
                }
                Text("Add an Image")
                    .fontWeight(.semibold)
                    .font(.system(size: 20))
            }.padding(.bottom, 20)
            
                fullFormTF(placeholder: "Community Title", txt: $model.communityName)
            HStack {
                CustomFullFormMultilineTF(text: $model.communityDescription, height: $model.descriptionTFHeight, placeholder: "Community Description")
                    .frame(height: model.descriptionTFHeight > 150 ? model.descriptionTFHeight : 150)
                    .padding([.leading, .trailing], 5)
                    .background(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                            ).padding()
            }
                
                
                if(model.alertTxt.count > 0) {
                    Text(model.alertTxt)
                        .foregroundColor(Color.red)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
                
            HStack {
                Button(action: {
                    model.isLoading.toggle()
                    model.validateCreation()
                }, label: {
                    Text("Create Community")
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(Color.white)
                        .padding()
                    
                })
                .onReceive(model.viewDismissalModePublisher) { shouldPop in
                    if shouldPop {
                        self.presentationmode.wrappedValue.dismiss()
                    }
                    print("hit")
                }
                .background(Color("ColorThemeMain"))
                .cornerRadius(15)
                .padding(.top)
            }
            
            Spacer()
            }
                if(model.isLoading) {
                    LoadingView()
                }
                Spacer()
            }
            Spacer()
        }
    }
}

struct CreateCommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCommunityView()
    }
}

