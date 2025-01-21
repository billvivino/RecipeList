//
//  RecipeListTests.swift
//  RecipeListTests
//
//  Created by Bill Vivino on 1/20/25.
//

import Testing
@testable import RecipeList

struct RecipeListTests {

    /// Test how the view model handles a successful fetch with valid recipes.
    @Test func testUpdateRecipesSuccess() async throws {
        // 1) Provide mock recipes
        let mockRecipes = [
            Recipe(
                cuisine: "Test Cuisine",
                name: "Test Recipe",
                photo_url_large: nil,
                photo_url_small: nil,
                source_url: nil,
                uuid: "test-uuid-123",
                youtube_url: nil
            )
        ]
        
        // 2) Create a mock service returning those recipes
        let service = MockRecipeService(scenario: .success(mockRecipes))
        
        // 3) Inject the service into the view model
        let viewModel = await RecipeViewModel(recipeService: service)
        
        // 4) Trigger the fetch
        await viewModel.updateRecipes()
        
        // 5) Verify the result
        await #expect(viewModel.recipes?.count == 1)
        await #expect(viewModel.recipes?.first?.name == "Test Recipe")
    }
    
    @Test func testUpdateRecipesEmpty() async throws {
        let service = MockRecipeService(scenario: .empty)
        let viewModel = await RecipeViewModel(recipeService: service)
        
        await viewModel.updateRecipes()
        
        // The view model should store an empty array, not nil
        await #expect(viewModel.recipes != nil)
        await #expect(viewModel.recipes?.isEmpty == true)
    }
    
    @Test func testUpdateRecipesMalformed() async throws {
        let service = MockRecipeService(scenario: .malformed)
        let viewModel = await RecipeViewModel(recipeService: service)
        
        await viewModel.updateRecipes()
        
        // Expect the fetch to fail, so recipes becomes nil, errorMessage is set
        await #expect(viewModel.recipes == nil)
        await #expect(viewModel.fetchError != nil)
    }
    
    @Test func testRealEndpointSuccess() async throws {
        let service = APIRecipeService()
        let viewModel = await RecipeViewModel(recipeService: service)
        
        await viewModel.updateRecipes()
        
        // Assuming the real JSON is valid, you might expect some non-empty array:
        await #expect(viewModel.recipes?.isEmpty == false)
    }
    
    @Test func malformedEndpointSuccess() async throws {
        let service = APIRecipeService()
        let viewModel = await RecipeViewModel(recipeService: service)
        
        await viewModel.updateRecipes(endpoint: .malformed)
        
        // Assuming the real JSON is valid, you might expect some non-empty array:
        await #expect(viewModel.recipes == nil)
    }
    
    @Test func emptyEndpointSuccess() async throws {
        let service = APIRecipeService()
        let viewModel = await RecipeViewModel(recipeService: service)
        
        await viewModel.updateRecipes(endpoint: .empty)
        
        let recipes = await viewModel.recipes
        #expect(recipes != nil)
        
        // Assuming the real JSON is valid, you might expect some non-empty array:
        #expect(recipes!.isEmpty)
    }
}
