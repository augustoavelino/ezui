//
//  AppDateFormatter.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 26/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class AppDateFormatter {
    
    // MARK: Properties
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    // MARK: Singleton
    
    static let shared = AppDateFormatter()
    
    // MARK: - File cycle
    
    fileprivate init() {}
    
    // MARK: - Formatting
    
    func string(from date: Date, format: String) -> String {
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    func date(from string: String, format: String) -> Date? {
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
}
