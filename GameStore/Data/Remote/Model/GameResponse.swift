//
//  GameRemote.swift
//  GameStore
//
//  Created by Deanu Haratinu on 16/09/23.
//
import Foundation

// MARK: - Welcome
struct GameResponse: Codable {
    let results: [GameResult?]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
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
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

// MARK: - PlatformElement
struct PlatformElement: Codable {
    let platform: PlatformPlatform

    enum CodingKeys: String, CodingKey {
        case platform
    }
}

// MARK: - PlatformPlatform
struct PlatformPlatform: Codable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

extension GameResponse {
    func toGameModel() -> [GameModel] {
        return self.results?.map { result in
            return GameModel(
                title: result?.name ?? "",
                releaseYear: result?.released ?? "",
                rating: Float(result?.rating ?? 0),
                imageUrl: result?.backgroundImage ?? "",
                platform: result?.platforms.first?.platform.name ?? ""
            )
        } ?? []
    }
}
