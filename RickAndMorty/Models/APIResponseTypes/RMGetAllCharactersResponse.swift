//
//  RMGetAllCharactersResponse.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/31.
//

import Foundation

struct RMGetAllCharacterResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [RMCharacter]
}
