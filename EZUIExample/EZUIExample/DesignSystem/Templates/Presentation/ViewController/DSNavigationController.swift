//
//  DSNavigationController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 22/09/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSNavigationController: UINavigationController {
    init(rootViewController: UIViewController, prefersLargeTitle: Bool = false) {
        super.init(rootViewController: rootViewController)
        navigationBar.prefersLargeTitles = prefersLargeTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
