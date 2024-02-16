//
//  RMEndpoint.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/20.
//

import Foundation

/// Represents unique API endpoint
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get character info
    case character
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
