//
//  InviteFriends.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/27/20.
//

import SwiftUI
import MobileCoreServices

struct InviteFriends: View {
    @Environment(\.presentationMode) var presentationmode
    
    @ObservedObject var user: User = .shared
    
    
    @StateObject var model = InviteFriendsViewModel()
    
    var body: some View {
            VStack{
                HStack{
                    
                    Image("BackIconBlue")
                        .resizable()
                        .frame(width: 40, height:40)
                        .padding(.trailing, 20)
                        .onTapGesture(count: 1){
                            self.presentationmode.wrappedValue.dismiss()
                        }
                    
                    Text("Invite Friends")
                        .font(.system(size: 32, weight: .bold))
                    Spacer()
                }
                .padding()
                .foregroundColor(.primary)
                .overlay(Rectangle().stroke(Color.primary.opacity(0.1), lineWidth: 1).shadow(radius: 3).edgesIgnoringSafeArea(.top))
                .padding(.bottom, -10)
                
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack{
                        Spacer()
                        ZStack {
                            Image("AbstractShape")
                                .resizable()
                                .frame(width:UIScreen.main.bounds.width / 1.75, height: UIScreen.main.bounds.width / 1.75)
                                .padding(.top, 0)
                        }
                    }
                    
                    if(model.QRImage != nil){
                        Image(uiImage: model.QRImage!)
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.width / 1.5)
                        Divider()
                            .padding(.leading, 25)
                            .padding(.trailing, 25)
                        
                        if(model.copied){
                            Text("Copied To Clipboard!")
                                .foregroundColor(.green)
                        } else {
                            Text("Click Here to Copy a Shareable Link ")
                                .foregroundColor(.blue)
                                .underline()
                                .onTapGesture (count: 1){
                                    UIPasteboard.general.setValue(model.ShareableLink,
                                                forPasteboardType: kUTTypePlainText as String)
                                    model.RemoveCopied()
                                    model.copied = true
                                }
                                .padding(.bottom, 7)
                        }
                    }
                    else{
                        Image("RedXIcon")

                        Divider()
                            .padding(.leading, 25)
                            .padding(.trailing, 25)
                        
                        if(model.copied){
                            Text("Copied To Clipboard!")
                                .foregroundColor(.green)
                        } else {
                        Text("Uh Oh, We Failed to Generate a QR Code. You Can Still Click Here To Get A Shareable Link")
                            .foregroundColor(.blue)
                            .underline()
                            .onTapGesture (count: 1){
                                UIPasteboard.general.setValue(model.ShareableLink,
                                            forPasteboardType: kUTTypePlainText as String)
                                model.RemoveCopied()
                                model.copied = true
                            }
                            .padding(.bottom, 7)
                            .multilineTextAlignment(.center)
                        }
                    }
                
                
                    Spacer()
                    HStack{
                        ZStack {
                            Image("AbstractShape")
                                .resizable()
                                .frame(width:UIScreen.main.bounds.width / 1.75, height: UIScreen.main.bounds.width / 1.75)
                                .padding(.top, 0)
                                .rotationEffect(.degrees(180))
                        }
                        Spacer()
                    }
                }
                
                
            }.ignoresSafeArea(.all, edges: .bottom)
    }
}
