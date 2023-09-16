//
//  ImageLoader.swift
//  GameStore
//
//  Created by Deanu Haratinu on 16/09/23.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
//    private let baseUrl = "https://api.rawg.io/api/games"
    let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: String, result: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: url)
        if let image = cache.object(forKey: cacheKey) {
            result(image)
            return
        }
        
        guard let url = URL(string: url) else {
            result(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                result(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                result(image)
            }
        }
        
        task.resume()
    }
}
