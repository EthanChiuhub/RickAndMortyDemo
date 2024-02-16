//
//  RMEpisodeDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/16.
//

import UIKit

class RMEpisodeDetailViewViewModel: NSObject {
    
    private var endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        guard let request = RMRequest(url: endpointUrl) else {
            return
        }
        
    }

}
