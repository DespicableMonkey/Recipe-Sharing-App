//
//  RecipePost.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/24/20.
//

import SwiftUI
import Foundation

struct RecipePost: View {
    @State var recipe : Recipe
    var body: some View {
        VStack {
            HStack {
                Image(recipe.image ?? "LoginBackground")
                    .resizable()
                    .contentShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 30)
                Text(recipe.creator)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                if(recipe.createdByUser){
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                }
            }
            GeometryReader{ g in
                
                VStack {
                    HStack {
                        Image("LoginBackground")
                        //.resizable()
                        //.aspectRatio(contentMode: .fill)
                    }
                    //Save Button
                    Divider()
                    HStack {
                        Text(recipe.detail)
                        Spacer()
                    }
                } .padding(.horizontal, recipe.expand ? 0 : 15)
                .offset(y: recipe.expand ? -g.frame(in: .global).minY : 0)
                
                
            }.frame(height: recipe.expand ? UIScreen.main.bounds.height : 300)
            .onTapGesture {

                recipe.expand.toggle()
               
            }.fullScreenCover(isPresented: $recipe.expand){
                RecipeInstructions(recipe: recipe)
            }
        }
        .padding()
        .background(Color.black.opacity(0.02))
        .cornerRadius(10)
    }
}

struct RecipePost_Previews: PreviewProvider {
    static var previews: some View {
        RecipePost( recipe: Recipe(image: nil, title: "Chocolate Lava Cake", detail: "A Gentle Combinated of Various Ingredients", upvotes: 0, type: "easy", color: Color(.blue), time: 30, timeUnit: "minutes", creator: "Despicable", creatorImage: nil, createdByUser: true, creation: "2 Hours Ago", expand: false))
    }
}
