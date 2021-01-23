import SwiftUI
import Foundation

struct RecipeCard: View {
    var recipe : Recipe
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            HStack{
                
                Spacer(minLength: 0)
                
                Image("LoginBackground")
                    .resizable()
                    .frame(width: 200, height: 190)
                    .aspectRatio(contentMode: .fill)
            }
            .padding(.bottom)
            
            Text(recipe.title)
                .font(.title3)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(spacing: 12){
                
                Label(title: {
                    Text("\(recipe.upvotes)")
                        .font(.caption)
                        .foregroundColor(Color("ColorThemeMain"))
                    
                }) {
                    //Replace with a rating system (chef hats instead of stars)
                    Image(systemName: "arrow.up.circle")
                        .font(.caption)
                        .foregroundColor(Color("ColorThemeMain"))
                }
                .padding(.vertical,5)
                .padding(.horizontal,10)
                .background(recipe.color.opacity(0.1))
                .cornerRadius(5)
                
                Text(recipe.type)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical,5)
                    .padding(.horizontal,10)
                    .background(recipe.color.opacity(0.1))
                    .cornerRadius(5)
                
                Text("\(recipe.time) \(recipe.timeUnit)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical,5)
                    .padding(.horizontal,10)
                    .background(recipe.color.opacity(0.1))
                    .cornerRadius(5)
            }
            
            Text(recipe.detail)
                .foregroundColor(.gray)
                .lineLimit(3)
            
            HStack{
                
                Spacer(minLength: 0)
                
                Button(action: {}) {
                    
                    Label(title: {
                        Text("Save")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                        
                    }) {
                        Image(systemName: "suit.heart")
                            .font(.body)
                            .foregroundColor(Color("ColorThemeMain"))
                    }
                    .padding(.vertical,8)
                    .padding(.horizontal,10)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
            }
        }
        .padding(.horizontal)
        // Max Width....
        .frame(width: UIScreen.main.bounds.width / 2)
        .background(
            recipe.color.opacity(0.2)
                .cornerRadius(25)
                .padding(.top,55)
                .padding(.bottom,15)
        )
    }
}
