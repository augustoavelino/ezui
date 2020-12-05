//
//  EZSelectionControl.swift
//  EZUI
//
//  Created by Augusto Avelino on 04/12/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZSelectionControl: EZControl {
    // MARK: Properties
    override open var isSelected: Bool {
        get { return super.isSelected }
        set {
            super.isSelected = newValue
            updateIsSelected()
        }
    }
    
    // MARK: - Life cycle
    public init(
        isSelected: Bool = false
    ) {
        super.init(frame: .zero)
        setupUI()
        self.isSelected = isSelected
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateIsSelected()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {}
    
    // MARK: - Events
    open override func onTapDown(_ sender: EZControl) {
        displayHighlightedState()
    }
    
    open override func onTapUpInside(_ sender: EZControl) {
        isSelected.toggle()
    }
    
    open override func onDragExit(_ sender: EZControl) {
        updateIsSelected()
    }
    
    open override func onDragEnter(_ sender: EZControl) {
        displayHighlightedState()
    }
    
    open override func onTapUpOutside(_ sender: EZControl) {
        updateIsSelected()
    }
    
    open override func onTapCancel(_ sender: EZControl) {
        updateIsSelected()
    }
    
    // MARK: - Display updates
    open func displayNormalState() {}
    open func displayHighlightedState() {}
    open func displaySelectedState() {}
    
    open func updateIsSelected() {
        if isSelected { displaySelectedState() }
        else { displayNormalState() }
    }
}
