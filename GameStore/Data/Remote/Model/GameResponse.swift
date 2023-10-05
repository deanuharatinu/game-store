import Foundation

// MARK: - Welcome
struct GameResponse: Codable {
    let results: [GameResult?]?
}

// MARK: - GameResult
struct GameResult: Codable {
    let id: Int
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let ratingTop: Int?
    let platforms: [PlatformElement]
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case ratingTop = "rating_top"
        case platforms
        case genres
    }
}

// MARK: - Genre
struct Genre: Codable {
    let name: String?
}

// MARK: - PlatformElement
struct PlatformElement: Codable {
    let platform: PlatformPlatform
}

// MARK: - PlatformPlatform
struct PlatformPlatform: Codable {
    let name: String?
}

extension GameResponse {
    
    func toGameModel() -> [GameModel] {
        return self.results?.map { result in
            return GameModel(
                id: String(result?.id ?? 0),
                title: result?.name ?? "",
                releaseYear: result?.released ?? "",
                rating: Float(result?.rating ?? 0),
                imageUrl: result?.backgroundImage ?? "",
                platform: result?.platforms.first?.platform.name ?? ""
            )
        } ?? []
    }
    
}
