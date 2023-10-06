//
//  DocumentationMenuViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 18/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI

// MARK: Action

enum DocumentationMenuAction: DSActionType {
    case selectItem(indexPath: IndexPath)
    
    var identifier: String {
        switch self {
        case .selectItem(let indexPath): return "documentation_menu/item/\(indexPath)"
        }
    }
}

// MARK: - Protocol

protocol DocumentationMenuViewModelProtocol: DSViewModelProtocol where ActionType == DocumentationMenuAction {}

// MARK: - View model

class DocumentationMenuViewModel: DocumentationMenuViewModelProtocol {
    typealias ActionType = DocumentationMenuAction
    
    var delegate: DSViewModelDelegate?
    
    func performAction(_ actionType: ActionType) {
        
    }
}
