//
//  RMsettingsCellViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/22.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable, Hashable {
    var id = UUID()
    
     // MARK: - Init
    private let type: RMSettingsOption
    
    init(type: RMSettingsOption) {
        self.type = type
    }
    
     // MARK: - Public
    public var title: String {
        return type.disPlayTitle
    }
    
    public var image: UIImage? {
        return type.iconImage
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}
