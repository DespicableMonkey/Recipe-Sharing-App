//
//  CreateRecipeView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/25/20.
//

import SwiftUI
import SPAlert


struct CreateRecipeView: View {
    @StateObject var model = AddRecipeViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                    Image("BackIcon")
                        .padding()
                })
                
                Spacer()
                
                Button(action: {
                    model.publishMediate()
                }, label: {
                    Text("Publish")
                        .foregroundColor(Color.white)
                        .padding([.top, .bottom])
                        .padding([.trailing, .leading])
                        .overlay(!(model.recipeTitle.length > 0 && model.description.length > 0 && model.servings.length > 0 && model.difficulty.length > 0 && model.cookTime.length > 0 && model.ingredients.count > 0 && model.ingredients[0].length > 0 && model.steps.count > 0 && model.steps[0].length > 0) ? Color.gray.opacity(0.5) : Color.gray.opacity(0))
                })
                .background(Color("ColorThemeMain"))
                .cornerRadius(10)
                .padding(.trailing, 20)
                .disabled(!(model.recipeTitle.length > 0 && model.description.length > 0 && model.servings.length > 0 && model.difficulty.length > 0 && model.cookTime.length > 0 && model.ingredients.count > 0 && model.ingredients[0].length > 0 && model.steps.count > 0 && model.steps[0].length > 0))
            }
            Divider()
            ScrollView(.vertical, showsIndicators: false, content: {
                Button(action: {}, label: {
                    VStack {
                        Image(systemName: "camera")
                            .resizable()
                            .foregroundColor(Color("ColorThemeMain"))
                            .frame(width: 50, height: 40)
                        Text("Upload Recipe Photo")
                            .foregroundColor(Color("ColorThemeMain"))
                            .font(.title)
                        
                    }
                    
                })
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2/7 )
                .background(Color.gray.opacity(0.15))
                
                Divider()
                
                HStack {
                    VStack {
                        Text("Details")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        
                        CustomTextField_V3(placeholder: "Chocolate Chip Cookies", target: "Recipe Title", limit: 64, txt: $model.recipeTitle)
                        CustomTextField_V3(placeholder: "A spectacular mix of chocolate and batter", target: "Short Description", limit: 64, txt: $model.description)
                        CustomTextField_V3(placeholder: "3 People", target: "Servings", limit: 64, txt: $model.servings)
                        CustomTextField_V3(placeholder: "45 Minutes", target: "Cook Time", limit: 64, txt: $model.cookTime)
                        CustomTextField_V3(placeholder: "Medium", target: "Difficulty", limit: 64, txt: $model.difficulty)
                    }.padding()
                    
                }
                .background(Color.white)
                .padding([.leading, .trailing], 10)
                .cornerRadius(5)
                
                HStack {
                    VStack {
                        Text("Ingredients")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        ForEach(0..<model.ingredients.count, id: \.self){ index in
                            HStack {
                                CustomTextField_V3(placeholder: "250ml Water", target: "", limit: 64, txt: $model.ingredients[index])
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color.red)
                                    .onTapGesture {
                                        if(model.ingredients.count > 1){
                                            model.ingredients.remove(at: index)
                                        }
                                    }
                            }
                        }
                        
                        
                        Button(action: {
                            model.ingredients.append("")
                            
                        }, label: {
                            HStack (alignment: .center){
                                Image(systemName: "plus")
                                    .padding(.trailing,2)
                                    .foregroundColor(Color("ColorThemeMain"))
                                Text("Ingredient")
                                    .font(.title3)
                                    .foregroundColor(Color("ColorThemeMain"))
                            }
                        })
                        .padding(.bottom, 10)
                    }
                }
                .background(Color.white)
                .padding([.leading, .trailing], 10)
                .cornerRadius(5)
                
                HStack {
                    VStack {
                        Text("Steps")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        ForEach(0..<model.steps.count, id: \.self){ index in
                            RecipeStepView(txt: $model.steps[index], img: $model.stepImages[index], presentImgPicker: $model.stepImagePresents[index], txtHeight: $model.stepTFHeights[index], stepNumber: index+1)
                        }
                        Button(action: {
                            model.steps.append("")
                            model.stepTFHeights.append(0)
                            model.stepImages.append(UIImage())
                            model.stepImagePresents.append(false)
                        }, label: {
                            HStack (alignment: .center){
                                Image(systemName: "plus")
                                    .padding(.trailing,2)
                                    .foregroundColor(Color("ColorThemeMain"))
                                Text("Step")
                                    .font(.title3)
                                    .foregroundColor(Color("ColorThemeMain"))
                            }
                        })
                        .padding(.bottom, 10)
                    }
                }
                .background(Color.white)
                .padding([.leading, .trailing], 10)
                .cornerRadius(5)
            })

            
        }.background(Color.gray.opacity(0.05))
        .onReceive(model.viewDismissalModePublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct RecipeStepView : View {
    
    @Binding var txt : String
    @Binding var img: UIImage
    @Binding var presentImgPicker : Bool
    @Binding var txtHeight: CGFloat
    var stepNumber : Int
    
    
    var body : some View {
        HStack {
            VStack (spacing: 8){
                HStack (spacing : 8) {
                    
                    ZStack {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("ColorThemeMain"))
                        Text("#\(stepNumber)")
                            .foregroundColor(.white)
                    }
                    .padding()
                    MultilineTextField("Step #\(stepNumber)", text: $txt)
                    
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding()
                        .onTapGesture {
//                            if(model.steps.count > 1){
//                                model.steps.remove(at: 1)
//                            }
                        }
                }
                .padding()
                
                if(img != UIImage()){
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .sheet(isPresented: $presentImgPicker, content: {
                            ImagePickerView(isPresented: $presentImgPicker, image: $img)
                        })
                        .onTapGesture {
                           presentImgPicker.toggle()
                        }
                    
                    Image(systemName: "trash")
                        .foregroundColor(Color.red)
                        .onTapGesture {
                          img = UIImage()
                        }
                }
               else {
                    VStack (spacing: 20){
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .scaledToFit()
                            .padding([.top, .leading, .trailing])
                        Text("Add an Image")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.bottom, .leading, .trailing])

                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .sheet(isPresented: $presentImgPicker, content: {
                        ImagePickerView(isPresented: $presentImgPicker, image: $img)
                    })
                    .onTapGesture {
                        presentImgPicker.toggle()
                    }
                }
                
                
            }
            .padding()
        }
        .padding(.bottom, 40)
        .padding(.trailing, 10)
    }
}
