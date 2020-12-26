//
//  RecipeInstructions.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/24/20.
//

import SwiftUI

struct RecipeInstructions: View {
    @State var recipe : Recipe
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        
        ScrollView(.vertical, showsIndicators: false, content: {
            ZStack {
                
            GeometryReader{reader in
                
                if reader.frame(in: .global).minY > -480 {
                    Image(recipe.image ?? "TestImage1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .offset(y: -reader.frame(in: .global).minY)
                        .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 480 : 480)
                }
                VStack {
                    HStack {
                        HStack {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray.opacity(0.5))
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            HStack  (spacing: 10){
                                Image(systemName: "suit.heart")
                                    .resizable()
                                    .foregroundColor(Color("ColorThemeMain"))
                                    .frame(width: 25, height: 25)
                                if(recipe.createdByUser) {
                                    Image(systemName: "ellipsis")
                                        .rotationEffect(.degrees(-90))
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(15)
                            
                        }
                    }
                    Spacer()
                }.padding()
            }
            .frame(height: 480)
                

            }
            VStack(alignment: .leading,spacing: 15){
                
                Text(recipe.title)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    
                
                HStack(spacing: 15){
                    
                    ForEach(0..<(recipe.upvotes ), id: \.self){ _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.white)
                    }
                    ForEach(0..<(5 - recipe.upvotes ), id: \.self){ _ in
                        Image(systemName: "star")
                            .foregroundColor(.white)
                    }
                }
                
                HStack {
                    Image("LoginBackground")
                        .resizable()
                        .frame(width: 50, height: 45)
                    Text(recipe.creator)
                        .font(.title3)
                        .foregroundColor(.white)
                    Spacer()
                }.padding(.bottom, 20)
                
                Text(recipe.detail)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.top,5)
                
                
                Divider()
                    .foregroundColor(.white)
                
                HStack (spacing: 20){
                    HStack {
                        Text(recipe.type)
                            .padding()
                            .foregroundColor(.white)
                            .font(.title3)
                    }
                    .background(Color.blue.opacity(0.95))
                    .cornerRadius(10)
                    
                    HStack {
                        HStack {
                            Image(systemName: "timer")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color("ColorThemeMain"))
                               
                            Text("\(recipe.time) \(recipe.timeUnit)")
                                 .foregroundColor(.white)
                                .font(.title3)
                        }
                        .padding()
                    }
                    .background(Color.blue.opacity(0.95))
                    .cornerRadius(10)
                }
                
                Text(plot)
                    .padding(.top, 10)
                    .foregroundColor(.white)
                
            }
            .padding(.top, 25)
            .padding(.horizontal)
            .background(Color.black)
            .cornerRadius(20)
            .offset(y: -35)
        })
        .edgesIgnoringSafeArea(.all)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct RecipeInstructions_Previews: PreviewProvider {
    static var previews: some View {
        RecipeInstructions(recipe: Recipe(image: "TestImage1", title: "Chocolate Lava Cake", detail: "A Gentle Combinated of Various Ingredients", upvotes: 3, type: "easy", color: Color(.blue), time: 30, timeUnit: "minutes", creator: "Despicable", creatorImage: nil, createdByUser: true, creation: "2 Hours Ago", expand: false))
            .previewDevice("iPhone 12 Pro Max")
    }
}
var plot = "Nine years earlier, following the events of Toy Story 2, Bo Peep and Woody attempt to rescue RC, Andy's remote-controlled car, from a rainstorm. Just as they finish the rescue, Woody watches as Bo is donated to a new owner, and considers going with her, but ultimately decides to remain with Andy. Years later, a young adult Andy donates them to Bonnie, a younger child, before he goes off to college. While the toys are grateful to have a new child, Woody struggles to adapt to an environment where he is not the favorite as he was with Andy, apparent when Bonnie takes Woody's sheriff badge and puts it on Jessie instead, not even bothering to give him a role during her playtime.On the day of Bonnie's kindergarten orientation, Woody worries over her and sneaks into her backpack. After a classmate takes away Bonnie's arts and crafts supplies, Woody covertly recovers the materials and various pieces of garbage from the trash, including a plastic spork. Bonnie uses these to create a bipedal spork with googly eyes, whom she dubs Forky. Forky comes to life in Bonnie's backpack and begins to experience an existential crisis, thinking he is garbage rather than a toy and wishing to remain in a trash can. As Forky becomes Bonnie's favorite toy, Woody takes it upon himself to prevent Forky from throwing himself away......."

//
//  RecipePost.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/24/20.
//
