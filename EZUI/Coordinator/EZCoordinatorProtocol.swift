//
//  EZCoordinatorProtocol.swift
//  EZUI
//
//  Created by Augusto Avelino on 04/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

public protocol EZRouteProtocol {
    var identifier: String { get }
}

public protocol EZCoordinatorProtocol: AnyObject {
    associatedtype Route: EZRouteProtocol
    
    var identifier: String { get }
    var parent: (any EZCoordinatorProtocol)? { get set }
    var children: [any EZCoordinatorProtocol] { get set }
    
    var navigationController: UINavigationController? { get set }
    
    func performRoute(_ route: Route, animated: Bool)
    
    func start(animated: Bool)
    func addChild(_ coordinator: any EZCoordinatorProtocol)
    func removeFromParent()
}

public extension EZCoordinatorProtocol {
    var identifier: String { "\(Self.self)" }
    
    func addChild(_ coodinator: any EZCoordinatorProtocol) {
        coodinator.parent = self
        children.append(coodinator)
    }
    
    func removeFromParent() {
        if let childIndex = parent?.children.lastIndex(where: { $0.identifier == identifier }) {
            parent?.children.remove(at: childIndex)
        }
        parent = nil
    }
}
