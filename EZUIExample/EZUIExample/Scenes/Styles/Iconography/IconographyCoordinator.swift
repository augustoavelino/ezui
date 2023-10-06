//
//  IconographyCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 04/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum IconographyRoute: EZRouteProtocol {
    case back, demo, list, detail
    
    var identifier: String {
        switch self {
        case .back: return "typography/back"
        case .demo: return "typography/demo"
        case .list: return "typography/list"
        case .detail: return "typography/detail"
        }
    }
}

protocol IconographyCoordinatorProtocol: AnyObject {
    func performRoute(_ route: IconographyRoute, animated: Bool)
}

class IconographyCoordinator: DSCoordinator<IconographyRoute>, IconographyCoordinatorProtocol {
    
    // MARK: - Life cycle
    
    override func start(animated: Bool = true) {
        performRoute(.demo, animated: animated)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: IconographyRoute, animated: Bool = true) {
        switch route {
        case .back: removeFromParent()
        case .demo: presentDemo(animated: animated)
        default: return
        }
    }
    
    func presentDemo(animated: Bool) {
        let repository = IconographyRepository()
        let viewModel = IconographyDemoViewModel(repository: repository, coordinator: self)
        let viewController = IconographyDemoViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
