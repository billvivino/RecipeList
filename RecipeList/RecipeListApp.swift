//
//  RecipeListApp.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

import SwiftUI

@main
struct RecipeListApp: App {
    let recipeService: RecipeServiceProtocol = APIRecipeService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                recipeViewModel: RecipeViewModel(
                    recipeService: recipeService
                )
            )
        }
    }
}
