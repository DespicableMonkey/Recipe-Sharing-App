//
//  CreateRecipeView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 12/25/20.
//

import SwiftUI



struct CreateRecipeView: View {
    @StateObject var model = AddRecipeViewModel()
    
    @State var isShowingImagePicker = false
    
    
    var body: some View {
        VStack {
            HStack {
                Image("BackIcon")
                    .padding()
                
                Spacer()
                
                Button(action: {}, label: {
                    Text("Publish")
                        .foregroundColor(.white)
                        .padding([.top, .bottom])
                        .padding([.trailing, .leading])
                        .overlay(model.disabledPublish ? Color.gray.opacity(0.5) : Color.gray.opacity(0))
                })
                .background(Color("ColorThemeMain"))
                .cornerRadius(10)
                .padding(.trailing, 20)
                .disabled(model.disabledPublish)
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
                    VStack (alignment: .leading){
                        Text("Details")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        CustomTextField_V2(placeholder: "Recipe Title", txt: $model.recipeTitle, fontSize: .title)
                        
                        CustomTextField_V2(placeholder: "Short Description", txt: $model.description, fontSize: .title3)
                        
                        CustomTextField_V2(placeholder: "Serves: 3 people", txt: $model.servings, fontSize: .title3)
                        
                        CustomTextField_V2(placeholder: "Cook Time: 45 minutes", txt: $model.cookTime, fontSize: .title3)
                        
                        CustomTextField_V2(placeholder: "Difficulty: Meduim", txt: $model.difficulty, fontSize: .title3)
                    }
                }
                .background(Color.white)
                .padding([.leading, .trailing], 10)
                .cornerRadius(5)
                
                HStack {
                    VStack (alignment: .leading){
                        Text("Ingredients")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        ForEach(0..<model.ingredients.count, id: \.self){ index in
                            HStack {
                                Image(systemName: "trash")
                                    .onTapGesture {
                                        if(model.ingredients.count > 1){
                                            model.ingredients.remove(at: index)
                                        }
                                    }
                                CustomTextField_V2(placeholder: "250ml Water", txt: $model.ingredients[index], fontSize: .title3)
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
                    VStack (alignment: .leading){
                        Text("Steps")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        ForEach(0..<model.steps.count, id: \.self){ index in
                            HStack {
                                VStack (spacing: 8){
                                    HStack (spacing : 8) {
                                        
                                        ZStack {
                                            Circle()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(Color("ColorThemeMain"))
                                            Text("#\(index+1)")
                                                .foregroundColor(.white)
                                        }
                                        
                                        CustomMultilineTF(text: $model.steps[index], height: $model.stepTFHeights[index], placeholder: "Step #\(index+1)")
                                            .frame(height: model.stepTFHeights[index] < 300 ? model.stepTFHeights[index] : 300 )
                                            .background(Color.white)
                                            .cornerRadius(10)
                                        
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .onTapGesture {
                                                if(model.steps.count > 1){
                                                    model.steps.remove(at: 1)
                                                }
                                            }
                                    }
                                    
                                    if(model.stepImages[index] != nil) {
                                        Image(uiImage: model.stepImages[index]!)
                                            .resizable()
                                            //.renderingMode(.original)
                                            .scaledToFit()
                                            .frame(width: 150, height: 150)
                                            .sheet(isPresented: $isShowingImagePicker, content: {
                                                ImagePickerView(isPresented: self.$isShowingImagePicker, image: $model.stepImages[index])
                                            })
                                            .onTapGesture {
                                                self.isShowingImagePicker.toggle()
                                            }
                                        
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .onTapGesture {
                                                model.stepImages[index] = nil
                                            }
                                        
                                        
                                    } else {
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
                                        .sheet(isPresented: $isShowingImagePicker, content: {
                                            ImagePickerView(isPresented: self.$isShowingImagePicker, image: $model.stepImages[index])
                                        })
                                        .onTapGesture {
                                            self.isShowingImagePicker.toggle()
                                        }
                                    }
                                    
                                }
                            }
                            
                            
                            .padding(.bottom, 40)
                            .padding(.trailing, 10)
                        }
                        Button(action: {
                            model.steps.append("")
                            model.stepTFHeights.append(0)
                            model.stepImages.append(nil)
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
            Spacer()
        }.background(Color.gray.opacity(0.05))
    }
}

