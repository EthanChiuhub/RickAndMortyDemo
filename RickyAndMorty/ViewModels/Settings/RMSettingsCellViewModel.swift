//
//  RMsettingsCellViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/22.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    var id = UUID()
    
    // MARK: - Init
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
     // MARK: - Public
    
    public let type: RMSettingsOption
    
    public let onTapHandler: (RMSettingsOption) -> Void
    
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
