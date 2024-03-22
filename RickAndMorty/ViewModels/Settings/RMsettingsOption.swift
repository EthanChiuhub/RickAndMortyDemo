//
//  RMsettingsOption.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/22.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley")
        case .terms:
            return URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley")
        case .privacy:
            return URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley")
        case .apiReference:
            return URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley")
        case .viewCode:
            return URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ&ab_channel=RickAstley")
        }
    }
    
    var disPlayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of Servic"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .systemPurple
        case .viewCode:
            return .systemPink
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
