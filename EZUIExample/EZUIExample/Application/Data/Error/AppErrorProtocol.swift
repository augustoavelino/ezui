//
//  AppErrorProtocol.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 24/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol AppErrorProtocol {
    var domain: String { get }
    var code: Int { get }
    var message: String { get }
}
