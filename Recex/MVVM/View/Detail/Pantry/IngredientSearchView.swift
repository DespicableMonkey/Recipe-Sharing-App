//
//  IngredientSearchView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/2/20.
//

import SwiftUI

struct IngredientSearchView: View {
    @Environment(\.presentationMode) var presentationmode
    
    @State private var isEditing  = false
    
    @StateObject var model = IngredientsViewModel()
    var target : String
    
    var body: some View {
        
        VStack {
            HStack {
                Text("Search Ingredients")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.leading, 10)
                    .foregroundColor(.black)
                    .onAppear(){ self.model.target = self.target}
                Spacer()
                Image(systemName: "multiply.circle.fill")
                    .onTapGesture {
                        self.presentationmode.wrappedValue.dismiss()
                    }
                    .padding(.trailing, 20)
                    .aspectRatio(contentMode: .fill)
            }
            HStack {
                
                TextField("Search Ingredients...", text: $model.searchText)
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
                                    model.searchText = ""
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
                        model.searchText = ""
                    }){
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.default)
                }
            }
            Divider()
            if(model.searchText.count == 0){
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
                    List(model.searchIngredients()) { ingredient in
                        IngredientSearchResultView(ingredient: ingredient, model: model, target: self.model.target)
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
    var ingredient : Ingredient
     @ObservedObject var model :IngredientsViewModel
    
        @State var checked : Bool = false
        @State var trimVal : CGFloat = 0
        @State var width : CGFloat = 70
        @State var removeText = false

    
    let target : String
    var body : some View {
        
                //checked -> current state of the checkbox.
                Button(action: {
                }) {
                    HStack {
                    AnimatedCheckMarkView(checked: $checked, trimVal: $trimVal, width: $width, removeText: $removeText)
                        .onAppear() {
                                self.checked = model.containsValue(for: target, ingredient: self.ingredient.name)
                                self.removeText = checked ? true : false
                                self.trimVal = checked ? 1 : 0
                                self.width = 70
                        }
                        .onTapGesture {
                            if(self.checked) {
                                model.updateList(for: target, ingredient: self.ingredient.name, action: false)
                            } else {
                                model.updateList(for: target, ingredient: self.ingredient.name, action: true)
                            }
                            if(!self.checked) {
                                self.removeText.toggle()
                                withAnimation{
                                    self.width = 70
                                }
                                withAnimation(Animation.easeIn(duration: 0.7)) {
                                    self.trimVal = 7
                                    self.checked.toggle()
                                }
                            } else {
                                self.trimVal = 0
                                self.width = 70
                                self.checked.toggle()
                                self.removeText.toggle()
                            }
                        }
                    Text(ingredient.name)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.system(size: 20))
                    Spacer()
                    }
                }
            .padding(.leading, 5)
            Divider()
                .padding([.leading, .trailing], 10)
    }
}
