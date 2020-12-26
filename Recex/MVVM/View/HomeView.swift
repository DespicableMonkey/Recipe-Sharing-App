//
//  HomeView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/27/20.
//

import SwiftUI

struct HomeView: View {
     @State var FeedRecipes = [
        Recipe(image: nil, title: "Chocolate Lava Cake", detail: "A Gentle Combinated of Various Ingredients", upvotes: 0, type: "easy", color: Color(.blue), time: 30, timeUnit: "minutes", creator: "Despicable", creatorImage: nil, createdByUser: true, creation: "2 Hours Ago", expand: false),
        
        Recipe(image: nil, title: "Buffaflo Pizza", detail: "A Gentle Combinated of Various Ingredients", upvotes: 5, type: "medium", color: Color(.yellow), time: 2, timeUnit: "hours", creator: "Babji", creatorImage: nil, createdByUser: false, creation: "Yesterday", expand: false)
        
    ]
    @State var hero = false
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Spacer()
                }
                
                ScrollView(.vertical, showsIndicators: false ) {
                    VStack {
                        HStack {
                            Text("Top This Week")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding(.top, 50)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(TopRecipes, id: \.title){ recipe in
                                    RecipeCard(recipe: recipe)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        HStack {
                            Text("Your Feed")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding(.top, 50)
                        
                        
                        VStack(spacing: 20){
                            ForEach(0..<FeedRecipes.count){ recipe in
                                RecipePost(recipe: FeedRecipes[recipe])
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.opacity(0.05).ignoresSafeArea(.all, edges: .all))
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
