//
//  StringsCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum StringsRoute: EZRouteProtocol {
    case back
    case list
    case associatedList(projectID: String)
    case detail(stringsFile: StringsFile)
    
    var identifier: String {
        switch self {
        case .back: return "strings/back"
        case .list: return "strings/list"
        case .associatedList(let projectID): return "strings/list/\(projectID)"
        case .detail(let stringsFile): return "strings/detail" + (stringsFile.uuid ?? "unidentified")
        }
    }
}

protocol StringsCoordinatorProtocol: AnyObject {
    func performRoute(_ route: StringsRoute, animated: Bool)
}

class StringsCoordinator: DSCoordinator<StringsRoute>, StringsCoordinatorProtocol {
    
    // MARK: - Life cycle
    
    override func start(animated: Bool = true) {
        performRoute(.list, animated: animated)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: StringsRoute, animated: Bool = true) {
        switch route {
        case .back: removeFromParent()
        case .list: presentList(animated: animated)
        case .associatedList(let projectID): presentAssociatedList(projectID: projectID, animated: animated)
        case .detail(let stringsFile): presentDetail(stringsFile: stringsFile, animated: animated)
        }
    }
    
    func presentList(animated: Bool = true) {
        let repository = StringsListRepository()
        let viewModel = StringsListViewModel(repository: repository, coordinator: self)
        let viewController = StringsListViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentAssociatedList(projectID: String, animated: Bool) {
        let repository = ProjectStringsPickerRepository(projectID: projectID)
        let viewModel = StringsListViewModel(repository: repository, coordinator: self)
        let viewController = StringsListViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentDetail(stringsFile: StringsFile, animated: Bool = true) {
        let repository = StringsDetailRepository(stringsFile: stringsFile)
        let viewModel = StringsDetailViewModel(repository: repository, coordinator: self)
        let viewController = StringsDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: animated)
    }
}
