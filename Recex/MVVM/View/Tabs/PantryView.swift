//
//  PantryView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/27/20.
//

import SwiftUI

struct PantryView: View {
    
    @ObservedObject var user: User = .shared

    @State var openNeeded = false 
    init() {
        //Testing
        
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    self.openNeeded = true
                }) {
                    Text("Needed Ingredients")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                    Spacer()
                    
                    Image("RightArrow")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 20)
                }
            
                    
                //Spacer()
            }.frame(width: UIScreen.main.bounds.width - 30)
            .background(Color("ColorThemeMain"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding(.bottom, 30)
            .fullScreenCover(isPresented: self.$openNeeded
                             , content: { NeededIngredients() })
            
            HStack{
                Button(action: {
                    
                }) {
                    Text("Owned Ingredients")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.leading, 20)
                    Spacer()
                    
                    Image("RightArrow")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 20)
                }
            
                    
                //Spacer()
            }.frame(width: UIScreen.main.bounds.width - 30)
            .background(Color("ColorThemeMain"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding(.bottom, 30)
            

           
            VStack{
                Divider()
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
            }
            if user.PantryBookmarked.count > 0 {
            HStack {
                Text("Saved Recipes")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.leading, 20)

                Spacer()
            }
            } else {
            VStack{
                Image("BookmarkOpen")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 125, height: 125)
                    .padding(.top, 50)
                    .padding(.bottom, 20)
                Text("Bookmarked Recipes")
                    .font(.system(size: 30, weight: .bold))
                Text("When You Bookmark Recipes From Community & Global Posts, They'll Appear Here in Your Virtual Pantry ")
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width / 1.1)
                    .foregroundColor(Color.gray)
                }
            }
            Spacer()
        }
        
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        PantryView()
    }
}
