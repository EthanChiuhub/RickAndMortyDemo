//
//  RMGetAllEpisodesResponse.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/19.
//

import Foundation

struct RMGetEpisodesResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [RMEpisode]
}
