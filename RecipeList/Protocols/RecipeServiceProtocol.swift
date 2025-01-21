//
//  RecipeServiceProtocol.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes(endpoint: RecipeEndpoint) async throws -> [Recipe]
}
