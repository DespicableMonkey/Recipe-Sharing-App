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
                        IngredientSearchResultView(ingredient: .constant(ingredient), selected: .constant((true)))
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
     @Binding var selected : Bool
    
        @State var checked =  false
        @State var trimVal : CGFloat = 0
        @State var width : CGFloat = 70
        @State var removeText = false

    
    init(ingredient : Binding<Ingredient>, selected : Binding<Bool>) {
        self._ingredient = ingredient
        self._selected = selected
        
        if ( true) {
            self.checked.toggle()
        }
    }
    var body : some View {
        

                Button(action: {
                        if !self.checked {
                            self.removeText.toggle()
                            withAnimation() {
                                self.width = 70
                            }
                            withAnimation(Animation.easeIn(duration: 0.3)) {
                                self.trimVal = 1
                                self.checked.toggle()
                            }
                        } else {
                            withAnimation() {
                                self.trimVal = 0
                                self.width = 70
                                self.checked.toggle()
                                self.removeText.toggle()
                            }
                        }
                }) {
                    HStack {
                    AnimatedCheckMarkView(checked: $checked, trimVal: $trimVal, width: $width, removeText: $removeText)
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
struct IngredientSearchView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientSearchView()
    }
}

