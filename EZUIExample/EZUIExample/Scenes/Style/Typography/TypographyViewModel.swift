//
//  TypographyViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 11/08/22.
//  Copyright © 2022 Augusto Avelino. All rights reserved.
//

import UIKit

protocol TypographyViewModelProtocol {
    var textData: [(text: String, textStyle: UIFont.TextStyle)] { get }
}

class TypographyViewModel: TypographyViewModelProtocol {
    
    // MARK: Properties
    
    let textData: [(text: String, textStyle: UIFont.TextStyle)] = [
        ("Large Title", .largeTitle),
        ("Title 1", .title1),
        ("Title 2", .title2),
        ("Title 3", .title3),
        ("Headline", .headline),
        ("Subheadline", .subheadline),
        ("Body", .body),
        ("Callout", .callout),
        ("Footnote", .footnote),
        ("Caption 1", .caption1),
        ("Caption 2", .caption2),
    ]
}
