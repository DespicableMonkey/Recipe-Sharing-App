//
//  CustomTextFields.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/26/20.
//

import Foundation
import SwiftUI

struct CustomTextField_V2 : View {
    var placeholder : String
    @Binding var txt : String
    var fontSize : Font
    
    var body : some View{
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)){
            ZStack{
                TextField(placeholder, text: $txt)
                    .font(fontSize)
            }
            .padding(.horizontal)
            .frame(height: 60)
            .clipShape(Capsule())
            Divider()
                .frame(height: 1)
                .padding(.horizontal)
                .background(Color.black.opacity(0.2))
                .padding(.top, 30)
                .padding(.trailing, 20)
                .padding(.leading, 10)
            
        }
        .padding(.horizontal)
    }
}

struct fullFormTF : View {
    var placeholder : String
    @Binding var txt : String
    var body : some View {
            TextField(self.placeholder, text: $txt)
                .padding([.leading, .trailing], 5)
                .padding([.top, .bottom], 15)
                .background(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color.gray.opacity(0.7), lineWidth: 1)
                        ).padding()
    }
}
struct CustomTextField_V3 : View {
     var placeholder : String
     var target : String
    var limit : Int?
    @Binding var txt: String
    
    var body : some View {
        VStack {
            HStack {
                Text(target)
                    .foregroundColor(Color.gray)
                    .font(.callout)
                
                Spacer()
            }.padding([.leading, .trailing], 30)
            .padding(.bottom, -7)
            
            
            RoundedRectangle(cornerRadius: 5).foregroundColor(Color.init(hex: "#F0F0F0").opacity(0.95))
                
                .overlay(  TextField(self.placeholder, text: $txt)
                            .font(.system(size: 15))
                            .padding()
                            .foregroundColor(Color.black)
                            .padding(.leading, 5)
                            .padding([.top, .bottom], 0)
                            .onChange(of: self.txt, perform: { value in
                                if let max = self.limit {
                                    txt = txt.limit(limit: max)
                                }
                              })
                )
                            
                .padding([.leading, .trailing], 30)
                .frame(height: 50)
        }
    }
}
