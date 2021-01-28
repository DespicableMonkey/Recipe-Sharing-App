//
//  ContentView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/23/20.
//
import SwiftUI
import CoreData
import CommonCrypto
import PromiseKit

struct ContentView: View {
    @StateObject var model = ModelData()
    
    var body: some View {
        
        ZStack{
            //open the login view
                LoginView(model: model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice("iPhone 11 Pro").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}






