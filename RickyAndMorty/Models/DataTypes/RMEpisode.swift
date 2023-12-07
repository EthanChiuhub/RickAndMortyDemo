//
//  RMEpisode.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/19.
//

import Foundation

struct RMEpisode: Codable {
    let id: Int
    let name: String
    let airdate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
}
