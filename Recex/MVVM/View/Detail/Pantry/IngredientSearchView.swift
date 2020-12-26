//
//  IngredientSearchView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/2/20.
//

import SwiftUI

struct IngredientSearchView: View {
    @Environment(\.presentationMode) var presentationmode
    
    @Binding var searchTxt: String
    @State private var isEditing  = false
    
    @StateObject var model = IngredientsViewModel()
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Search Ingredients")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.leading, 10)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "multiply.circle.fill")
                    .onTapGesture {
                        self.presentationmode.wrappedValue.dismiss()
                    }
                    .padding(.trailing, 20)
                    .aspectRatio(contentMode: .fill)
            }
            HStack {
                
                TextField("Search Ingredients...", text: $searchTxt)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.searchTxt = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                if isEditing {
                    Button(action:{
                        self.isEditing = false
                        self.searchTxt = ""
                    }){
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            Divider()
            if(model.searchText.count != 0){
                VStack {
                    Text(model.alertText)
                            .multilineTextAlignment(.center)
                            .font(.title2)
                            .foregroundColor(Color("ColorThemeMain"))
                }
            }
            else {
            HStack {
                VStack (spacing: 0){
                    Text("lol")
                    ScrollView(.vertical, showsIndicators: false){
                       
//                        ForEach(model.searchedIngredients){ingredient in
//                            IngredientSearchResultView(ingredient: .constant(ingredient))
//                        }
//                        List(model.ingredients.filter({ model.searchText.isEmpty ? true : $0.name.contains(model.searchText) })) { ingredient in
//                            IngredientSearchResultView(ingredient: .constant(ingredient))
//                        }
                    }
                    .padding(.top)
                }
                Spacer()
            }
            }
            Spacer()
        }
        
        .padding(.top, 10)
    }
}


struct IngredientSearchResultView : View {
     @Binding var ingredient : Ingredient
    
    var body : some View {
            HStack {
                Button(action: {}) {
                    Circle()
                        .overlay(
                            Circle()
                                .stroke(Color.gray,lineWidth: 5)
                        ).foregroundColor(.clear)
                        .frame(width: 17, height: 17, alignment: .center)
                        .padding(.trailing, 10)
                    Text(ingredient.name)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                }
                Spacer()
            }
            .padding(.leading, 15)
            Divider()
                .padding([.leading, .trailing], 10)
        .onTapGesture {}
    }
}
struct IngredientSearchView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientSearchView(searchTxt: .constant(""))
    }
}

