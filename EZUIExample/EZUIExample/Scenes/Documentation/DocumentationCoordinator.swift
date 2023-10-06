//
//  DocumentationCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/09/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum DocumentationRoute: EZRouteProtocol {
    case back
    case root
    
    var identifier: String {
        switch self {
        case .back: return "documentation/back"
        case .root: return "documentation/root"
        }
    }
}

protocol DocumentationCoordinatorProtocol: AnyObject {
    func performRoute(_ route: DocumentationRoute, animated: Bool)
}

class DocumentationCoordinator: DSCoordinator<DocumentationRoute>, DSRootChildCoordinatorProtocol, DocumentationCoordinatorProtocol {
    
    // MARK: Properties
    
    lazy var rootViewController: UIViewController = makeRootController()
    
    // MARK: - Life cycle
    
    override init() {
        super.init()
        // TODO: verificar weak na navigationController
        navigationController = DSNavigationController(
            rootViewController: rootViewController,
            prefersLargeTitle: true
        )
    }
    
    override func start(animated: Bool = false) {
        performRoute(.root, animated: animated)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: Route, animated: Bool = true) {
        switch route {
        case .back: removeFromParent()
        case .root: presentRoot(animated: animated)
        }
    }
    
    func makeRootController() -> UIViewController {
        let viewModel = DocumentationMenuViewModel()
        let viewController = DocumentationMenuViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        return viewController
    }
    
    func presentRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
        for child in children {
            child.removeFromParent()
        }
    }
}
