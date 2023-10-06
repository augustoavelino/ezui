//
//  NSError+Extensions.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 15/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

extension NSError {
    convenience init(domain: String, code: Int, localizedDescription: String) {
        self.init(
            domain: domain,
            code: code,
            userInfo: [NSLocalizedDescriptionKey: localizedDescription]
        )
    }
}
