//
//  RMGetLocationsResponse.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/25.
//
import Foundation

struct RMGetLocationsResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [RMLocation]
}
