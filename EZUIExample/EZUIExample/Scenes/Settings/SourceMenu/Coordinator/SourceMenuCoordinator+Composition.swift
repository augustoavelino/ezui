//
//  SourceMenuCoordinator+Templates.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI

extension SourceMenuRoute {
    enum Composition: EZRouteProtocol {
        case viewController
        case viewLayout
        
        var identifier: String {
            switch self {
            case .viewController: return "composition/viewController"
            case .viewLayout: return "composition/viewLayout"
            }
        }
    }
}

extension SourceMenuCoordinator {
    func performCompositionRoute(_ route: SourceMenuRoute.Composition, animated: Bool) {
        switch route {
        case .viewLayout: presentViewLayout()
        default: return
        }
    }
    
    func presentViewLayout() {
        navigationController?.pushViewController(
            ViewLayoutViewController(viewModel: ViewLayoutViewModel()),
            animated: true
        )
    }
}
