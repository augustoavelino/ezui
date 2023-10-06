//
//  SourceMenuCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum SourceMenuRoute: EZRouteProtocol {
    case back
    case root
    case resources(Resources)
    case styles(Styles)
    case composition(Composition)
    
    var identifier: String {
        switch self {
        case .back: return "source_menu/back"
        case .root: return "source_menu/root"
        case .resources(let resourcesRoute): return "source_menu/" + resourcesRoute.identifier
        case .styles(let stylesRoute): return "source_menu/" + stylesRoute.identifier
        case .composition(let compositionRoute): return "source_menu/" + compositionRoute.identifier
        }
    }
}

protocol SourceMenuCoordinatorProtocol: AnyObject {
    func performRoute(_ route: SourceMenuRoute, animated: Bool)
}

class SourceMenuCoordinator: DSCoordinator<SourceMenuRoute>, DSRootChildCoordinatorProtocol, SourceMenuCoordinatorProtocol {
    
    // MARK: Properties
    
    lazy var rootViewController: UIViewController = makeRootController()
    
    // MARK: - Life cycle
    
    override func start(animated: Bool = false) {
        performRoute(.root)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: Route, animated: Bool = true) {
        switch route {
        case .back: removeFromParent()
        case .root: presentRoot(animated: animated)
        case .resources(let resourcesRoute): performResourcesRoute(resourcesRoute, animated: animated)
        case .styles(let styleRoute): performStylesRoute(styleRoute, animated: animated)
        case .composition(let templatesRoute): performCompositionRoute(templatesRoute, animated: animated)
        }
    }
    
    // TODO: Corrigir retain cycle
    func makeRootController() -> UIViewController {
        let viewModel = SourceMenuViewModel(coordinator: self)
        let viewController = SourceMenuViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        return viewController
    }
    
    func presentRoot(animated: Bool = true) {
        guard let navigationController = navigationController else { return }
        if navigationController.viewControllers.contains(rootViewController) {
            navigationController.popToViewController(rootViewController, animated: animated)
        } else {
            navigationController.pushViewController(rootViewController, animated: animated)
        }
        for child in children {
            child.removeFromParent()
        }
    }
    
    // MARK: - Helpers
    
    func addAndStart(_ coordinator: any EZCoordinatorProtocol, animated: Bool = true) {
        addChild(coordinator)
        coordinator.start(animated: animated)
    }
}
