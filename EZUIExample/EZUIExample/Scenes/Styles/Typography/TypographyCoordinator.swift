//
//  TypographyCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 04/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum TypographyRoute: EZRouteProtocol {
    case back, demo, list, detail, info(Documentation)
    
    var identifier: String {
        switch self {
        case .back: return "typography/back"
        case .demo: return "typography/demo"
        case .list: return "typography/list"
        case .detail: return "typography/detail"
        case .info(let doc): return "typography/info/\(doc.title)"
        }
    }
}

protocol TypographyCoordinatorProtocol: AnyObject {
    func performRoute(_ route: TypographyRoute, animated: Bool)
}

class TypographyCoordinator: DSCoordinator<TypographyRoute>, TypographyCoordinatorProtocol {
    
    // MARK: - Life cycle
    
    override func start(animated: Bool = true) {
        performRoute(.demo, animated: animated)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: TypographyRoute, animated: Bool = true) {
        switch route {
        case .back: removeFromParent()
        case .demo: presentDemo(animated: animated)
        case .info(let documentation): presentDocumentation(documentation)
        default: return
        }
    }
    
    func presentDemo(animated: Bool) {
        let repository = TypographyDemoRepository()
        let viewModel = TypographyDemoViewModel(repository: repository, coordinator: self)
        let viewController = TypographyDemoViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        push(viewController, animated: animated)
    }
    
    func presentDocumentation(_ documentation: Documentation) {
        let viewModel = DocViewModel(documentation: documentation)
        let viewController = DocViewController(viewModel: viewModel)
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}
