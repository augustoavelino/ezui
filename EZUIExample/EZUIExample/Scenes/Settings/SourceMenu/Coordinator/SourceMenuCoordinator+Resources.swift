//
//  SourceMenuCoordinator+Resources.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 28/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI

extension SourceMenuRoute {
    enum Resources: EZRouteProtocol {
        case strings
        
        var identifier: String {
            switch self {
            case .strings: return "resources/strings"
            }
        }
    }
}

extension SourceMenuCoordinator {
    func performResourcesRoute(_ route: SourceMenuRoute.Resources, animated: Bool) {
        switch route {
        case .strings: presentStrings(animated: animated)
        }
    }
    
    func presentStrings(animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        let coordinator = StringsCoordinator(navigationController: navigationController)
        addAndStart(coordinator, animated: animated)
    }
}
