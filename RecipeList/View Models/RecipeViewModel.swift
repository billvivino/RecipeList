//
//  RecipeViewModel.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

import SwiftUI
import Combine

@MainActor
final class RecipeViewModel: ObservableObject, Sendable {
    private let recipeService: RecipeServiceProtocol
    @Published var recipes: [Recipe]?
    @Published var isLoading: Bool = false
    @Published var fetchError: Error?
    var screenFrame: CGRect = .zero

    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
    }

    func updateRecipes(endpoint: RecipeEndpoint = .all) async {
        isLoading = true
        fetchError = nil

        do {
            let data = try await recipeService.fetchRecipes(endpoint: endpoint)
            self.recipes = data
        } catch {
            self.fetchError = error
            self.recipes = nil
        }
        
        isLoading = false
    }
}
