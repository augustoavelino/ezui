//
//  EZTextField.swift
//  EZUI
//
//  Created by Augusto Avelino on 04/12/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZTextField: UITextField {
    // MARK: Nested types
    public typealias TextChangeEvent = (String?) -> Void
    public typealias EditingEvent = (EZTextField) -> Void
    
    // MARK: - Properties
    open var onTextDidChange: TextChangeEvent?
    open var onEditingBegan: EditingEvent?
    open var onEditingChanged: EditingEvent?
    open var onEditingEnded: EditingEvent?
    
    // MARK: - Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupEvents()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    open func setupEvents() {
        addTarget(self, action: #selector(EZTextField.onTextChangeEvent(_:)), for: .valueChanged)
        addTarget(self, action: #selector(EZTextField.onEditingBeganEvent(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(EZTextField.onEditingChangedEvent(_:)), for: .editingChanged)
        addTarget(self, action: #selector(EZTextField.onEditingEndedEvent(_:)), for: .editingDidEnd)
    }
    
    // MARK: - Events
    @objc open func onTextChangeEvent(_ sender: EZTextField) {
        onTextDidChange?(sender.text)
    }
    
    @objc open func onEditingBeganEvent(_ sender: EZTextField) {
        onEditingBegan?(sender)
    }
    
    @objc open func onEditingChangedEvent(_ sender: EZTextField) {
        onEditingChanged?(sender)
    }
    
    @objc open func onEditingEndedEvent(_ sender: EZTextField) {
        onEditingEnded?(sender)
    }
}
