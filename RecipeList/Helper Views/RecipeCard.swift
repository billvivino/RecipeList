//
//  RecipeCard.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

import SwiftUI

struct RecipeCard: View {
    @EnvironmentObject var recipeViewModel: RecipeViewModel
    func getFrame(_ proxy: GeometryProxy) -> Bool {
        DispatchQueue.main.async {
            self.imageWidth = proxy.size.width
        }
        return true
    }
    let recipe: Recipe
    @State private var image: Image?
    @State private var imageWidth: CGFloat = .zero
    
    var body: some View {
        VStack (spacing: 8) {
            Text(recipe.cuisine)
                .font(.largeTitle)
                .bold()
            Text(recipe.name)
                .font(.body)
                .bold()
            
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
            } else {
                Color.gray
                    .frame(maxWidth: .infinity)
                    .frame(
                        height: self.imageWidth
                    )
                    .background {
                        GeometryReader { proxy in
                            if getFrame(proxy) {
                                Color.clear
                            }
                        }
                    }
            }
            if let source_url = recipe.source_url {
                Link(destination: URL(string: source_url)!) {
                    Text("Read more...")
                }
                .font(.body)
            }
            if let youtube_url = recipe.youtube_url {
                Link(destination: URL(string: youtube_url)!) {
                    Text("Watch video...")
                }
                .font(.body)
            }
        }
        .padding()
        .onAppear {
            if let photoUrl = recipe.photo_url_large {
                if let image = CacheService.shared.getImage(forKey: photoUrl) {
                    self.image = Image(uiImage: image)
                    print(recipe.name + " Already cached")
                } else {
                    print(recipe.name + " Fetch")
                    Task {
                        if let image = await CacheService.shared.saveImage(from: photoUrl, forKey: photoUrl) {
                            self.image = Image(uiImage: image)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    RecipeCard(
        recipe: Recipe(
            cuisine: "Aermic",
            name: "Aermic’s Herb-Infused Pasta",
            photo_url_large: "https://example.com/images/pasta-large.jpg",
            photo_url_small: "https://example.com/images/pasta-small.jpg",
            source_url: "https://example.com/recipes/aermic-pasta",
            uuid: "3e38d09f-6264-4784-945e-71f2a2c78cd1",
            youtube_url: "https://youtube.com/watch?v=dQw4w9WgXcQ"
        )
    )
}
