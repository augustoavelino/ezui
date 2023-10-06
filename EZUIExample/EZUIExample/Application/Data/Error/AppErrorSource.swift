//
//  AppErrorSource.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 24/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol AppErrorSource {
    associatedtype AppErrorType: AppErrorProtocol
    func error(_ appError: AppErrorType) -> NSError
}

extension AppErrorSource {
    func error(_ appError: AppErrorType) -> NSError {
        return NSError(
            domain: appError.domain,
            code: appError.code,
            localizedDescription: appError.message
        )
    }
}
