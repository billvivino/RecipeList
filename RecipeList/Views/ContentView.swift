//
//  ContentView.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var recipeViewModel: RecipeViewModel
    
    init(recipeViewModel: RecipeViewModel) {
        _recipeViewModel = StateObject(wrappedValue: recipeViewModel)
    }
    
    func getFrame(_ proxy: GeometryProxy) -> Bool {
        recipeViewModel.screenFrame = proxy.frame(in: .global)
        return true
    }
    
    var recipeEndpoint: RecipeEndpoint = .all
    
    var body: some View {
        VStack {
            Text("Recipe App")
                .font(.largeTitle)
                .bold()
            if let recipes = recipeViewModel.recipes,
                !recipes.isEmpty {
                ScrollView {
                    LazyVStack {
                        ForEach(recipes, id: \.uuid) { recipe in
                            RecipeCard(recipe: recipe)
                        }
                    }
                }
                .padding()
            } else if recipeViewModel.fetchError != nil {
                VStack {
                    Text("Error: Invalid recipe list.\nPlease try again later.")
                        .font(.title)
                        .foregroundStyle(.red)
                }
                .frame(maxHeight: .infinity)
            } else {
                VStack {
                    Text("No Recipes Available.")
                        .font(.title)
                        .foregroundStyle(.gray)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .environmentObject(recipeViewModel)
        .task {
            await recipeViewModel.updateRecipes(endpoint: recipeEndpoint)
        }
        .refreshable {
            Task {
                await recipeViewModel.updateRecipes(endpoint: recipeEndpoint)
            }
        }
        .background {
            GeometryReader { proxy in
                if getFrame(proxy) {
                    Color.clear
                }
            }
        }
    }
}

#Preview {
    ContentView(
        recipeViewModel: RecipeViewModel(
            recipeService: APIRecipeService()
        )
    )
}
