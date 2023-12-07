//
//  RMCharacter.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/19.
//

import Foundation

struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let location: RMSingletLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}
