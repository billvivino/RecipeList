//
//  CacheServiceTests.swift
//  RecipeList
//
//  Created by Bill Vivino on 1/20/25.
//

import Testing
import SwiftUI
@testable import RecipeList

final class CacheServiceTests {
    
    @Test func testSaveAndGetImage() async {
        let testImage = "https://picsum.photos/200/300"
        let key = "testKey"
        
        CacheService.shared.clearCache()  // Reset before test, confirm nil
        #expect(CacheService.shared.getImage(forKey: key) == nil)
        
        await CacheService.shared.saveImage(from: testImage, forKey: key)
        
        let retrieved = CacheService.shared.getImage(forKey: key)
        #expect((retrieved != nil))
    }
    
    @Test func testClearCache() async {
        let testImage = "https://picsum.photos/200/300"
        let key = "testKey"
        
        await CacheService.shared.saveImage(from: testImage, forKey: key)
        #expect(CacheService.shared.getImage(forKey: key) != nil)
        
        CacheService.shared.clearCache()
        #expect(CacheService.shared.getImage(forKey: key) == nil)
    }
    
    @Test func testRemoveImage() async {
        let testImage = "https://picsum.photos/200/300"
        let key = "testKey"
        
        await CacheService.shared.saveImage(from: testImage, forKey: key)
        #expect(CacheService.shared.getImage(forKey: key) != nil)
        
        CacheService.shared.removeImage(forKey: key)
        #expect(CacheService.shared.getImage(forKey: key) == nil)
    }
}
