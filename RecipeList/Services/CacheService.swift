//
//  CacheService.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

import Foundation
import SwiftUI

struct CacheService {
    
    static let shared = CacheService()
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    private init() {
        // Example configuration:
        // imageCache.countLimit = 100           // Limit to 100 images in memory
        // imageCache.totalCostLimit = 1024 * 50  // Limit total memory cost in bytes
    }
    
    @discardableResult
    func saveImage(from urlString: String, forKey key: String) async -> UIImage? {
        do {
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let downloadedImage = UIImage(data: data) else {
                throw URLError(.cannotDecodeRawData)
            }
            
            let nsKey = key as NSString
            imageCache.setObject(downloadedImage, forKey: nsKey)
            
            return downloadedImage
        } catch {
            return nil
        }
    }

    func getImage(forKey key: String) -> UIImage? {
        let nsKey = key as NSString
        return imageCache.object(forKey: nsKey)
    }
    
    func removeImage(forKey key: String) {
        let nsKey = key as NSString
        imageCache.removeObject(forKey: nsKey)
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
}

