//
//  GameDetailEntity.swift
//  GameStore
//
//  Created by Deanu Haratinu on 05/10/23.
//

import Foundation

struct GameDetailEntity: Codable {
    let id: String
    let title: String
    let releaseYear: String
    let rating: Float
    let imageUrl: String
    let platform: String
    let genre: String
    let description: String
}

extension GameDetailModel {
    func toGameDetailEntity() -> GameDetailEntity {
        GameDetailEntity(
            id: self.id,
            title: self.title,
            releaseYear: self.releaseYear,
            rating: self.rating,
            imageUrl: self.imageUrl,
            platform: self.platform,
            genre: self.genre,
            description: self.description
        )
    }
}

extension GameDetailEntity {
    func toGameDetailModel() -> GameDetailModel {
        GameDetailModel(
            id: self.id,
            title: self.title,
            releaseYear: self.releaseYear,
            rating: self.rating,
            imageUrl: self.imageUrl,
            platform: self.platform,
            genre: self.genre,
            description: self.description
        )
    }
}
