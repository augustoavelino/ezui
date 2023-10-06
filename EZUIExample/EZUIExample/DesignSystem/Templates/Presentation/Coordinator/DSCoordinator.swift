//
//  DSCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 04/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol DSRootChildCoordinatorProtocol: EZCoordinatorProtocol {
    var rootViewController: UIViewController { get }
}

class DSCoordinator<Route: EZRouteProtocol>: EZCoordinatorProtocol {
    func performRoute(_ route: Route, animated: Bool) {}
    
    // MARK: Properties
    
    weak var parent: (any EZCoordinatorProtocol)?
    var children: [any EZCoordinatorProtocol] = []
    
    // MARK: UI
    
    weak var navigationController: UINavigationController?
    
    // MARK: - Life cycle
    
    func start(animated: Bool) {}
    
    init() {}
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("\(Self.self) DID INIT")
    }
    
    deinit { print("\(Self.self) DID DEINIT") }
    
    // MARK: - Presenting
    
    func push(_ destination: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(destination, animated: animated)
        }
    }
    
    func present(_ destination: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.navigationController?.present(destination, animated: animated, completion: completion)
        }
    }
}
