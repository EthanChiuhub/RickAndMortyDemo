//
//  RMEpisodeDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/16.
//

import UIKit
import Combine

class RMEpisodeDetailViewViewModel: NSObject {
    
    private var endpointUrl: URL?
    
    var cancellables = Set<AnyCancellable>()

    
    init(endpointUrl: URL?) {
        super.init()
        self.endpointUrl = endpointUrl
        self.fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        } receiveValue: { model in
            print(String(describing: model))
        }.store(in: &cancellables)

    }

}
