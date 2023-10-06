//
//  AppCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 09/06/23.
//

import EZUI
import UIKit

enum AppRoute: EZRouteProtocol {
    case main
    
    var identifier: String { "application/" }
}

class AppCoordinator: EZCoordinatorProtocol {
    typealias Route = AppRoute
    
    // MARK: Properties
    
    weak var parent: (any EZCoordinatorProtocol)?
    var children: [any EZCoordinatorProtocol] = []
    
    // MARK: UI
    
    weak var window: UIWindow?
    var navigationController: UINavigationController?
    weak var tabBarController: UITabBarController?
    
    // MARK: - Life cycle
    
    init(window: UIWindow) {
        self.window = window
        setup()
    }
    
    func start(animated: Bool = false) {
        let projectCoordinator = ProjectCoordinator()
        let documentationCoordinator = DocumentationCoordinator()
        let settingsCoordinator = SettingsCoordinator()
        do {
            let projectVC = try addRootChild(projectCoordinator).get()
            let documentationVC = try addRootChild(documentationCoordinator).get()
            let settingsVC = try addRootChild(settingsCoordinator).get()
            tabBarController?.setViewControllers([
                projectVC,
                documentationVC,
                settingsVC,
            ], animated: animated)
        } catch {
            tabBarController?.setViewControllers([UIViewController()], animated: animated)
            print(error)
        }
    }
    
    func performRoute(_ route: AppRoute, animated: Bool) {}
    
    // MARK: - Setup
    
    private func setup() {
        let tabBar = UITabBarController()
        window?.rootViewController = tabBar
        tabBarController = tabBar
    }
    
    // MARK: - Routing
    
    private func addRootChild(_ rootChild: any DSRootChildCoordinatorProtocol) -> Result<UIViewController, Error> {
        guard let viewController = rootChild.navigationController else {
            return .failure(NSError(domain: "AppCoordinator", code: 1001, localizedDescription: "ROOT CONTROLLER FOR FOUND IN \(rootChild)"))
        }
        addChild(rootChild)
        return .success(viewController)
    }
}
