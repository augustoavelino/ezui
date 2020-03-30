//
//  EZLayoutProxy.swift
//  EZUI
//
//  Created by Augusto Avelino on 14/03/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

// Based on John Sundell's DSL tutorial.
// (https://www.swiftbysundell.com/articles/building-dsls-in-swift/)

import UIKit

public class EZLayoutProxy {
    public lazy var centerX = property(with: view.centerXAnchor)
    public lazy var centerY = property(with: view.centerYAnchor)
    public lazy var top = property(with: view.topAnchor)
    public lazy var leading = property(with: view.leadingAnchor)
    public lazy var trailing = property(with: view.trailingAnchor)
    public lazy var left = property(with: view.leftAnchor)
    public lazy var right = property(with: view.rightAnchor)
    public lazy var bottom = property(with: view.bottomAnchor)
    public lazy var width = property(with: view.widthAnchor)
    public lazy var height = property(with: view.heightAnchor)
    
    private let view: UIView

    init(view: UIView) {
        self.view = view
    }

    private func property<Anchor: EZLayoutAnchor>(with anchor: Anchor) -> EZLayoutProperty<Anchor> {
        return EZLayoutProperty(anchor: anchor)
    }
}
