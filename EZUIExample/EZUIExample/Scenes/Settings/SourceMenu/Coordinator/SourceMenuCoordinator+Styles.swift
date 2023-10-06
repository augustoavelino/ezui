//
//  SourceMenuCoordinator+Styles.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI

// MARK: Routes

extension SourceMenuRoute {
    enum Styles: EZRouteProtocol {
        case colorPalette
        case typography
        case iconography
        
        var identifier: String {
            switch self {
            case .colorPalette: return "styles/colorPalette"
            case .typography: return "styles/typography"
            case .iconography: return "styles/iconography"
            }
        }
    }
}

// MARK: - Navigation

extension SourceMenuCoordinator {
    func performStylesRoute(_ route: SourceMenuRoute.Styles, animated: Bool = true) {
        switch route {
        case .colorPalette: presentColorPalette(animated: animated)
        case .typography: presentTypography(animated: animated)
        case .iconography: presentIconography(animated: animated)
        }
    }
    
    func presentColorPalette(animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        let coordinator = ColorPaletteCoordinator(navigationController: navigationController)
        addAndStart(coordinator, animated: animated)
    }
    
    func presentTypography(animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        let coordinator = TypographyCoordinator(navigationController: navigationController)
        addAndStart(coordinator, animated: animated)
    }
    
    func presentIconography(animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        let coordinator = IconographyCoordinator(navigationController: navigationController)
        addAndStart(coordinator, animated: animated)
    }
}
