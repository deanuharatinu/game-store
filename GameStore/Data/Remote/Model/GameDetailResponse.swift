import Foundation

// MARK: - GameDetailResponse
struct GameDetailResponse: Codable {
    let id: Int
    let name: String?
    let description: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let platforms: [PlatformElement?]?
    let genres: [Item?]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, released, platforms, genres, rating
        case backgroundImage = "background_image"
    }
}

// MARK: - item
struct Item: Codable {
    let name: String?
}

extension GameDetailResponse {
    
    func toGameDetailModel() -> GameDetailModel {
        let platform = self.platforms?
            .compactMap { $0?.platform.name }
            .joined(separator: ", ")
        let genre = self.genres?
            .compactMap { $0?.name }
            .joined(separator: ", ")
        let description = self.description?
            .replacingOccurrences(of: "<p>", with: "")
            .replacingOccurrences(of: "</p>", with: "")
            .replacingOccurrences(of: "<br />", with: "")
        
        return GameDetailModel(
            title: self.name ?? "",
            releaseYear: self.released ?? "",
            rating: Float(self.rating ?? 0),
            imageUrl: self.backgroundImage ?? "",
            platform: platform ?? "-",
            genre: genre ?? "-",
            description: description ?? ""
        )
    }
    
}
