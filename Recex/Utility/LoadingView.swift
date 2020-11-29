//
//  LoadingView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/25/20.
//

import SwiftUI

struct LoadingView: View {
    
    @State var animation = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(Color("ColorThemeMain"))
                .frame(width: 75, height: 75)
                .padding(50)
        }
        .background(Color.white)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4).ignoresSafeArea(.all, edges: .all))
        .onAppear(perform: {
            withAnimation(Animation.linear(duration: 1)){
                animation.toggle()
            }
        })
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
