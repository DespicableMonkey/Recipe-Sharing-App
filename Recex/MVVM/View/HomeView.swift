//
//  HomeView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/27/20.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            Text("Hello, World!")
                .navigationBarHidden(true)
                .navigationBarTitle("")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
