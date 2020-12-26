//
//  NeededIngredients.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/29/20.
//

import SwiftUI

struct NeededIngredients: View {
    @StateObject var model = NeededIngredientsViewModel()
    @Environment(\.presentationMode) var presentationmode
    
    @State var search = false
    
    var body: some View {
        VStack {
            HStack (spacing: 20){
                
                Button(action: {
                    self.presentationmode.wrappedValue.dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .heavy))
                        .padding(.leading, 10)
                        .foregroundColor(.black)
                }
                
             Text("Needed Ingredients")
                .font(.title)
                .fontWeight(.heavy)
                Spacer()
                
            }
            .padding()
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVStack (spacing: 0){
                    ForEach(model.ingredients){ ingredient in
                        IngredientView(ingredient: $model.ingredients[getIndex(item: ingredient)],ingredients:  $model.ingredients)
                        
                    }
                }
            }.background(Color(#colorLiteral(red: 0.9455228448, green: 0.9456811547, blue: 0.9455021024, alpha: 1)))
            
            VStack {
                HStack {
                    Text("Total")
                        .foregroundColor(.gray)
                        .fontWeight(.heavy)
                    Spacer()
                    
                    Text("\(model.ingredients.count) Ingredients")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
                .padding([.top, .horizontal])
                
                Button(action: {self.search = true}){
                    Text("Add Ingredient")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color(#colorLiteral(red: 0.2458183467, green: 0.6090428233, blue: 1, alpha: 1)))
                        .cornerRadius(15)
                        .sheet(isPresented: self.$search
                               , content: { IngredientSearchView(searchTxt: .constant("")) })
                }
            }
        }.background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)).ignoresSafeArea())
    }
    func getIndex(item: Ingredient) -> Int{
        return model.ingredients.firstIndex { (lookup) -> Bool in
            return item.id == lookup.id
        } ?? 0
    }
}

struct NeededIngredients_Previews: PreviewProvider {
    static var previews: some View {
        NeededIngredients()
    }
}
