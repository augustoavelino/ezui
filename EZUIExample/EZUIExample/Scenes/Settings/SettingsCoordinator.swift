//
//  SettingsCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 17/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol SettingsNameAlertDelegate: AnyObject {
    func alertDefaultName() -> String?
    func alert(_ alert: UIAlertController, didFinishWith authorName: String?)
}

enum SettingsRoute: EZRouteProtocol {
    case back
    case root
    case sourceMenu
    case authorNameAlert(SettingsNameAlertDelegate)
    
    var identifier: String {
        switch self {
        case .back: return "settings/back"
        case .root: return "settings/root"
        case .sourceMenu: return "settings/source_menu"
        case .authorNameAlert(_): return "settings/name_alert"
        }
    }
}

protocol SettingsCoordinatorProtocol: AnyObject {
    func performRoute(_ route: SettingsRoute, animated: Bool)
}

class SettingsCoordinator: DSCoordinator<SettingsRoute>, DSRootChildCoordinatorProtocol, SettingsCoordinatorProtocol {
    
    // MARK: Properties
    
    // TODO: Corrigir uso de navigationController. Corrigir também no parentCoordinator
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
    
    override func start(animated: Bool = true) {
        performRoute(.root, animated: animated)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: SettingsRoute, animated: Bool = true) {
        switch route {
        case .back: removeFromParent()
        case .root: presentRoot(animated: animated)
        case .sourceMenu: presentSourceMenu(animated: animated)
        case .authorNameAlert(let delegate): presentNameAlert(with: delegate)
        }
    }
    
    func makeRootController() -> UIViewController {
        let businessModel = SettingsRepository()
        let viewModel = SettingsViewModel(repository: businessModel, coordinator: self)
        let viewController = SettingsViewController(viewModel: viewModel)
        viewController.tabBarItem.image = UIImage(systemName: "gear")
        viewModel.delegate = viewController
        return viewController
    }
    
    func presentRoot(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
        for child in children {
            child.removeFromParent()
        }
    }
    
    func presentSourceMenu(animated: Bool) {
        // TODO: Corrigir ordem tab e navigation
        guard let navigation = navigationController else { return }
        let coordinator = SourceMenuCoordinator(navigationController: navigation)
        addChild(coordinator)
        coordinator.start(animated: animated)
    }
    
    // MARK: Presenting alerts
    
    func presentNameAlert(with delegate: SettingsNameAlertDelegate) {
        // TODO: Corrigir apresentação de alerts
//        presentTextFieldAlert(
//            title: "Edit Author",
//            message: "Choose a name",
//            textFieldText: delegate.alertDefaultName(),
//            textFieldPlaceholder: "Ex: Author",
//            actionBuilder: { alert, textField in
//                return UIAlertAction(title: "Confirm", style: .default) { [weak delegate, weak alert, weak textField] _ in
//                    guard let delegate = delegate,
//                          let alert = alert,
//                          let textField = textField else { return }
//                    delegate.alert(alert, didFinishWith: textField.text)
//                }
//            }
//        )
    }
}
