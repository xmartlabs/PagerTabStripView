//
//  ImageCache.swift
//  Example (iOS)
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//  Adapted by Xmartlabs from https://github.com/SchwiftyUI/NewsApiApp/blob/master/NewsApp/Model/UrlImageModel.swift
//

import Foundation
import SwiftUI

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
