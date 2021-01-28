//
//  RecipeSuggestionPost.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/28/21.
//

import SwiftUI

struct RecipeSuggestionView: View {
    @State var suggestion : recipeSuggestion
    @State var txt: String = ""
    @State var height: CGFloat = 20
    @State var shtOpen = false
    
    var body: some View {
        VStack {
            HStack {
                Image(uiImage: suggestion.creator_image!)
                    .resizable()
                    .contentShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 30)
                Text(suggestion.creator)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                if(suggestion.createdByUser){
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                }
            }
            VStack{
                Text("Looking for Inspiration!")
                    .font(.title2)
                    .fontWeight(.bold)
                VStack {
                    //Save Button
                    Divider()
                    HStack {
                        Text(suggestion.description)
                        Spacer()
                    }.padding()
                    
                    Button(action: {self.shtOpen.toggle()}, label: {
                        Text("View Owned Ingredients")
                            
                            .fontWeight(.bold)
                            .padding([.top, .bottom], 10)
                            .foregroundColor(Color.white)
                    })
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                Divider()
                
                
                UITextViewWrapper(text: $txt, calculatedHeight: $height)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .frame(maxHeight: 150)
                Button(action: {}, label: {
                    Text("Suggest")
                        
                        .fontWeight(.bold)
                        .padding([.top, .bottom], 10)
                        .foregroundColor(Color.white)
                })
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                Spacer()
                
                
                
            }.frame(height: 500).fullScreenCover(isPresented: $suggestion.expand){
                EmptyView()
            }
            BottomSheetView(isOpen: $shtOpen, maxHeight: 400, minHeightRatio: 0) {
                ScrollView() {
                    VStack {
                        ForEach(Array(self.suggestion.ingredients.keys), id: \.self) { k in
                            HStack{Text("\u{2022} \(k)(" + "\(suggestion.ingredients[k] ?? 0))")
                                .fontWeight(.bold)
                                .font(.title3)}
                                .frame(maxWidth: .infinity)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.02))
        .cornerRadius(10)
    }
}

struct RecipeSuggestionPost_Previews: PreviewProvider {
    static var previews: some View {
        RecipeSuggestionView(suggestion: recipeSuggestion(creator: "Babji", description: "Looking for recipes to cook today! I have the ingredients below, and I don't know what to cook, and help would be appreciated. Thanks!", ingredients: ["Tacos":2.0, "Vegetables": 4.0, "Tacos2":2.0, "Vegetables2": 4.0], postDate: "4 Days ago", createdByUser: true, expand: false))
    }
}
