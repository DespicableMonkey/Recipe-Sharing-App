//
//  ExploreView.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/27/21.
//

import SwiftUI

struct ExploreView: View {
    @State var searchText = "";
    @State var selectedFilter = 0
    
    private var topics : [String: Color] = ["Vegan" : .green, "Low Sugar" : .blue, "Low-Carb" : .gray, "Paleo" : .secondary, "Breakfast" : .black, "Lunch" : .purple, "Dinner" : .pink, "Snacks & Treats" :.yellow, "Dessert" :.red, "Gluten Free" : .orange]
    @State var communitiesList : [Community] = [Community(id: "", userIsIn: false, isPublic: false, joinCode: "", name: "Name", description: "description", image: UIImage(named: "TestImage1")!, participants: 1, chiefCook: "Me", notifications: 0)]
        
        
        
    private var searchFilters = ["All", "Accounts", "Recipes", "Communities"]
    var body: some View {
        VStack {
            VStack {
                SearchBar(text: self.$searchText)
                    .padding(.bottom)
                Picker(selection: $selectedFilter, label: Text("What is your favorite color?")) {
                    ForEach(0..<searchFilters.count) { index in
                        Text(self.searchFilters[index]).tag(index)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .padding(.bottom)
                .padding(.horizontal)
                
                Divider()
            }
            
            .background(Color.gray.opacity(0.05))
            
            HStack{
                Text("Categories")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                
                Spacer()
                
            }
            LazyVGrid(columns: [ GridItem(.fixed(UIScreen.main.bounds.width * 0.45), spacing: 16),  GridItem(.fixed(UIScreen.main.bounds.width * 0.45), spacing: 16)], alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(Array(topics.keys), id:\.self) { topic in
                    
                    ZStack {
                        topics[topic]
                            .frame(height: 40)
                            .cornerRadius(7)
                        Text(topic)
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                    }
                }
                
            })
            
            Divider()
                .padding()
            HStack{
                Text("Communities")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                Spacer()
                
            }
            
        ForEach(self.communitiesList) { community in
        CommunityListResultView(community: community)
            .background(Color("ColorThemeMain").opacity(0.4))
            .cornerRadius(5)
        }

            Divider()
                .padding()
            HStack{
                Text("People you might Know")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding()
                
                Spacer()
                
            }
            
            
            
            
            Spacer()
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}

fileprivate struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

