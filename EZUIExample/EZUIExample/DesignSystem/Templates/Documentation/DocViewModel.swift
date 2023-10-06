//
//  DocViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol DocViewModelProtocol {
    var documentation: Documentation { get }
}

class DocViewModel: DocViewModelProtocol {
    let documentation: Documentation
    
    init(documentation: Documentation) {
        self.documentation = documentation
    }
}
