//
//  AnimatedCheckMarkView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/26/20.
//

import SwiftUI
import Foundation

struct AnimatedCheckMarkView: View {
    @Binding var checked : Bool
    @Binding var trimVal : CGFloat
    @Binding var width: CGFloat
    @Binding var removeText : Bool
    
    
    var animatableData : CGFloat {
        get{ trimVal }
        set { trimVal = newValue }
    }
    
    var body: some View {
        ZStack {
            Capsule()
                .trim(from: 0, to: trimVal)
                .stroke(style: StrokeStyle(lineWidth: 2))
                .frame(width: width, height: 70)
                .foregroundColor(self.checked ? Color.green : Color.gray)
                .overlay(
                        Capsule()
                            .fill(self.checked ? Color.green : Color.gray.opacity(0.1))
                            .frame(width: self.width - 10, height: 60)
                )
            if checked {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white).opacity(Double(trimVal))
            }
            if !removeText{
                Text("Add")
                    .foregroundColor(Color("ColorThemeMain"))
                    .fontWeight(.bold)
            }
        }
    }
}
