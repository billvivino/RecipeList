//
//  APIRecipeService.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//
import Foundation

struct APIRecipeService: RecipeServiceProtocol {
    private struct RecipeAPIResponse: Decodable {
        let recipes: [Recipe]
    }
    
    func fetchRecipes(endpoint: RecipeEndpoint = .all) async throws -> [Recipe] {
        guard let url = URL(string: endpoint.urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoded = try JSONDecoder().decode(RecipeAPIResponse.self, from: data)
        
        let recipesToReturn = decoded.recipes.compactMap { recipe in
            Recipe(
                cuisine: recipe.cuisine,
                name: recipe.name,
                photo_url_large: recipe.photo_url_large,
                photo_url_small: recipe.photo_url_small,
                source_url: recipe.source_url,
                uuid: recipe.uuid,
                youtube_url: recipe.youtube_url
            )
        }
        
        return recipesToReturn
    }
}
