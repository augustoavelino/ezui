//
//  DSViewModelProtocol.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 07/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol DSViewModelProtocol {
    associatedtype ActionType: DSActionType
    var delegate: DSViewModelDelegate? { get set }
    func performAction(_ actionType: ActionType)
}

class DSViewModel<ActionType: DSActionType>: DSViewModelProtocol {
    weak var delegate: DSViewModelDelegate?
    func performAction(_ actionType: ActionType) {}
}
