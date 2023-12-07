//
//  RMCharacterStatus.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/20.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown

    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}
