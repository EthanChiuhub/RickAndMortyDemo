//
//  RMService.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/20.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singletion instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init() {}
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data or error
    public func execute(_ request: RMRequest , completion: @escaping () -> Void) {
        
    }
}
