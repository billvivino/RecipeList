//
//  MockRecipeService.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//


@testable import RecipeList
import Foundation

struct MockRecipeService: RecipeServiceProtocol {
    
    enum Scenario {
        case success([Recipe])   // Return valid recipes
        case empty              // Return an empty array
        case malformed          // Simulate a JSON decoding error
        case customError(Error) // Throw a custom error
    }
    
    let scenario: Scenario
    
    func fetchRecipes(endpoint: RecipeEndpoint = .all) async throws -> [Recipe] {
        switch scenario {
        case .success(let recipes):
            return recipes
            
        case .empty:
            return []
            
        case .malformed:
            // Simulate a decoding error
            throw URLError(.cannotDecodeRawData)
            
        case .customError(let error):
            throw error
        }
    }
}
