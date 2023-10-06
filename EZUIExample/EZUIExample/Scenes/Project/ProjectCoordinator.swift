//
//  ProjectCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 30/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum ProjectRoute: EZRouteProtocol {
    case root
    case detail(project: Project)
    case source(Source)
    
    var identifier: String {
        switch self {
        case .root: return "project/root"
        case .detail(let project): return "project/detail/" + (project.uuid ?? "unidentified")
        case .source(let source): return "project/source/" + source.identifier
        }
    }
}

protocol ProjectCoordinatorProtocol: AnyObject {
    func performRoute(_ route: ProjectRoute, animated: Bool)
}

class ProjectCoordinator: DSCoordinator<ProjectRoute>, DSRootChildCoordinatorProtocol, ProjectCoordinatorProtocol {
    
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
    
    override func start(animated: Bool = true) {
        performRoute(.root, animated: animated)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: ProjectRoute, animated: Bool = true) {
        switch route {
        case .root: presentRoot(animated: animated)
        case .detail(let project): presentDetail(project: project, animated: animated)
        case .source(let sourceRoute): performSourceRoute(sourceRoute, animated: animated)
        }
    }
    
    func presentRoot(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
        for child in children {
            child.removeFromParent()
        }
    }
    
    func presentDetail(project: Project, animated: Bool) {
        let repository = ProjectDetailRepository(project: project)
        let viewModel = ProjectDetailViewModel(repository: repository, coordinator: self)
        let viewController = ProjectDetailViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        push(viewController)
    }
    
    func makeRootController() -> UIViewController {
        let repository = ProjectListRepository()
        let viewModel = ProjectListViewModel(repository: repository, coordinator: self)
        let viewController = ProjectListViewController(viewModel: viewModel)
        viewController.tabBarItem.image = UIImage(systemName: "hammer.fill")
        viewModel.delegate = viewController
        return viewController
    }
    
    // TODO: Corrigir apresentação de alerts
//    func presentDeleteAlert(delegate: ProjectDeleteAlertDelegate) {
//        presentAlert(
//            title: "Delete Project",
//            message: "Are you sure you want to proceed?",
//            actionBuilder: { alert in
//                return UIAlertAction(title: "Delete", style: .destructive) { [weak delegate, weak alert] _ in
//                    guard let delegate = delegate,
//                          let alert = alert else { return }
//                    delegate.alertDidConfirmDeletion(alert)
//                }
//            },
//            cancelHandler: { [weak delegate] alert in
//                guard let delegate = delegate else { return }
//                delegate.alertDidCancel(alert)
//            }
//        )
//    }
}
