//
//  DSAction.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 07/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol DSActionType {
    var identifier: String { get }
}

typealias DSActionHandler = (UIAction, DSActionType) -> Void
