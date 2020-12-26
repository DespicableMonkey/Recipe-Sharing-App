//
//  IngredientView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 11/29/20.
//

import SwiftUI
import Foundation

struct IngredientView: View {
    
    @Binding var ingredient : Ingredient
    @Binding var ingredients : [Ingredient]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [Color(#colorLiteral(red: 0, green: 0.4939776659, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.4939776659, blue: 1, alpha: 1))]), startPoint: .leading, endPoint: .trailing)
            
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation(.easeIn){
                        deleteIngredient()
                    }
                }){
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 90, height: 50)
                }
            }
            
            HStack(spacing: 15){
                VStack(alignment: .leading, spacing: 10){
                    HStack(spacing: 15){
                        Text(ingredient.name)
                            .font(.title2)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
//                        Text("\(getRoundedQuantity(value: ingredient.quantity)) \(ingredient.unit)")
//                            .font(.title2)
//                            .fontWeight(.heavy)
//                            .foregroundColor(.black)
                        
                        Spacer(minLength: 0)
                        
                        Button(action: { if ingredient.quantity > 1 {ingredient.quantity -= 1}}){
                            Image(systemName: "minus")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.black)
                        }
                        
                        Text("\(getRoundedQuantity(value: ingredient.quantity))")
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.black.opacity(0.06))
                        
                        Button(action: {ingredient.quantity += 1}){
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .heavy))
                                .foregroundColor(.black)
                        }
                    }
                }
                
           
                
            }
            .padding()
            .background(Color(#colorLiteral(red: 0.9455228448, green: 0.9456811547, blue: 0.9455021024, alpha: 1)))
            .contentShape(Rectangle())
            .offset(x: ingredient.offset)
            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
        }
        Divider()
    }
    
    func onChanged(value: DragGesture.Value){
        if value.translation.width < 0 {
            if ingredient.isSwiped {
                ingredient.offset = value.translation.width - 90
            }
            else {
                ingredient.offset = value.translation.width
            }
        }
    }
    
    func onEnd(value: DragGesture.Value){
        
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    ingredient.offset = -1000
                    deleteIngredient()
                }
                else if -ingredient.offset > 50 {
                    ingredient.isSwiped = true
                    ingredient.offset = -90
                }
                else {
                    ingredient.isSwiped = false
                    ingredient.offset = 0
                }
            }
            else {
                ingredient.isSwiped = false
                ingredient.offset = 0
            }
            
        }
        
    }
    
    func deleteIngredient(){
        ingredients.removeAll { (ingredient) -> Bool in
            return self.ingredient.id == ingredient.id
        }
    }
    
}

func getRoundedQuantity(value : Double) -> String{
    let format = NumberFormatter()
    format.numberStyle = .decimal
    return format.string(from: NSNumber(value: value)) ?? " "
}
