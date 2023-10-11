import UIKit

private var apiKey: String {
    get {
        guard let filePath = Bundle.main.path(forResource: "TMDB-info", ofType: "plist") else {
            fatalError("Couldn't find file 'TMDB-Info.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'TMDB-Info.plist'.")
        }

        return value
    }
}

class NetworkManager {

    static let shared = NetworkManager()
    private let baseUrl = "https://api.rawg.io/api/games"

    func getGameList(pageSize: Int, completed: @escaping (Result<GameResponse, Error>) -> Void) {
        var components = URLComponents(string: baseUrl)
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "page_size", value: String(pageSize))
        ]

        guard let url = components?.url else {
            completed(.failure(GeneralError.error(errorMessage: "")))
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completed(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(GeneralError.error(errorMessage: "")))
                return
            }

            guard let data = data else {
                completed(.failure(GeneralError.error(errorMessage: "")))
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GameResponse.self, from: data)
                completed(.success(result))
            } catch {
                completed(.failure(GeneralError.error(errorMessage: "")))
                NSLog(error.localizedDescription)
                return
            }
        }

        task.resume()
    }

    func getGameDetail(gameId: String, completed: @escaping (Result<GameDetailResponse, Error>) -> Void) {
        var components = URLComponents(string: baseUrl + "/\(gameId)")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey)
        ]

        guard let url = components?.url else {
            completed(.failure(GeneralError.error(errorMessage: "")))
            return
        }

        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completed(.failure(error))
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(GeneralError.error(errorMessage: "")))
                return
            }

            guard let data = data else {
                completed(.failure(GeneralError.error(errorMessage: "")))
                return
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GameDetailResponse.self, from: data)
                completed(.success(result))
            } catch {
                completed(.failure(GeneralError.error(errorMessage: "")))
                NSLog(error.localizedDescription)
                return
            }
        }

        task.resume()
    }

}
