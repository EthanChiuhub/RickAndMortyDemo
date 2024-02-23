//
//  RMSettingsView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/23.
//

import SwiftUI

struct RMSettingsView: View {
    
    var viewModel: RMSettingsViewViewModel
    
    init(viewModel: RMSettingsViewViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.red)
                        .padding(8)
                        .background(Color(viewModel.iconContainerColor))
                        .cornerRadius(6)
                }
                Text(viewModel.title)
            }
            .padding(.bottom, 3)
        }
    }
}

#Preview {
    RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0)
    })))
}
