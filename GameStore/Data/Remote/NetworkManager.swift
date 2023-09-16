//
//  NetworkManager.swift
//  GameStore
//
//  Created by Deanu Haratinu on 14/09/23.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "3ea22d93b162402b8690ef1cc1535b36"
    private let baseUrl = "https://api.rawg.io/api/games"
    
    func getGameList(pageSize: Int, completed: @escaping (Result<GameResponse, Error>) -> Void) {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page_size", value: String(pageSize))
        ]
        
        guard let url = components?.url else {
            completed(.failure(NSError()))
            return
        }
        
        let request = URLRequest(url: url)
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(NSError()))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(NSError()))
                return
            }
                          
            guard let data = data else {
                completed(.failure(NSError()))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GameResponse.self, from: data)
                completed(.success(result))
            } catch {
                completed(.failure(NSError()))
                NSLog(error.localizedDescription)
                return
            }
        }
        
        task.resume()
    }
}
