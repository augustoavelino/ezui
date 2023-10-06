//
//  EZControl.swift
//  EZUI
//
//  Created by Augusto Avelino on 04/12/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZControl: UIControl {
    // MARK: Nested types
    public typealias OnTapEvent = (() -> Void)
    
    // MARK: - Props
    open var onTap: OnTapEvent?
    
    // MARK: - Life cycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupEvents()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    open func setupEvents() {
        addTarget(self, action: #selector(Self.onTouchDown(_:)), for: .touchDown)
        addTarget(self, action: #selector(Self.onTouchUpInside(_:)), for: .touchUpInside)
        addTarget(self, action: #selector(Self.onTouchUpOutside(_:)), for: .touchUpOutside)
        addTarget(self, action: #selector(Self.onTouchDragEnter(_:)), for: .touchDragEnter)
        addTarget(self, action: #selector(Self.onTouchDragExit(_:)), for: .touchDragExit)
        addTarget(self, action: #selector(Self.onTouchCancel(_:)), for: .touchCancel)
    }
    
    // MARK: - Events
    open func onTapDown(_ sender: EZControl) {}
    @objc private func onTouchDown(_ sender: EZControl) {
        onTapDown(sender)
    }
    
    open func onTapUpInside(_ sender: EZControl) {}
    @objc private func onTouchUpInside(_ sender: EZControl) {
        guard isEnabled else { return }
        onTapUpInside(sender)
        onTap?()
    }
    
    open func onTapUpOutside(_ sender: EZControl) {}
    @objc private func onTouchUpOutside(_ sender: EZControl) {
        guard isEnabled else { return }
        onTapUpOutside(sender)
    }
    
    open func onDragEnter(_ sender: EZControl) {}
    @objc private func onTouchDragEnter(_ sender: EZControl) {
        guard isEnabled else { return }
        onDragEnter(sender)
    }
    
    open func onDragExit(_ sender: EZControl) {}
    @objc private func onTouchDragExit(_ sender: EZControl) {
        guard isEnabled else { return }
        onDragExit(sender)
    }
    
    open func onTapCancel(_ sender: EZControl) {}
    @objc private func onTouchCancel(_ sender: EZControl) {
        guard isEnabled else { return }
        onTapCancel(sender)
    }
}
