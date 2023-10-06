//
//  ProjectCoordinator+Source.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 06/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI

extension ProjectRoute {
    enum Source: EZRouteProtocol {
        case iconography(projectID: String)
        case palettePicker(projectID: String)
        case strings(projectID: String)
        
        var identifier: String {
            switch self {
            case .iconography(let projectID): return "project/\(projectID)/iconography"
            case .palettePicker(let projectID): return "project/\(projectID)/palette_picker"
            case .strings(let projectID): return "project/\(projectID)/strings"
            }
        }
    }
}

extension ProjectCoordinator {
    func performSourceRoute(_ route: ProjectRoute.Source, animated: Bool) {
        switch route {
        case .iconography(let projectID): presentIconography(for: projectID, animated: animated)
        case .palettePicker(let projectID): presentPalettePicker(for: projectID, animated: animated)
        case .strings(let projectID): presentStringsList(for: projectID, animated: animated)
        }
    }
    
    func presentPalettePicker(for projectID: String, animated: Bool) {
        guard let navigationController = navigationController else { return }
        let coordinator = ColorPaletteCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.performRoute(.associatedList(projectID: projectID), animated: animated)
    }
    
    func presentStringsList(for projectID: String, animated: Bool) {
        guard let navigationController = navigationController else { return }
        let coordinator = StringsCoordinator(navigationController: navigationController)
        addChild(coordinator)
        coordinator.performRoute(.associatedList(projectID: projectID), animated: animated)
    }
    
    func presentIconography(for projectID: String, animated: Bool) {
        // TODO: Implementar criação de iconografias
    }
}
