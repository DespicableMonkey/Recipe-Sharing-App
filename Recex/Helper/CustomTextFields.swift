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
