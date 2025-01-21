//
//  Models.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

struct Recipe: Decodable, Sendable {
    let cuisine: String
    let name: String
    let photo_url_large: String?
    let photo_url_small: String?
    let source_url: String?
    let uuid: String
    let youtube_url: String?
}

enum RecipeEndpoint {
    case all
    case empty
    case malformed
    
    /// Returns the corresponding URL string for each endpoint.
    var urlString: String {
        switch self {
        case .all:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case .empty:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        case .malformed:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        }
    }
}
