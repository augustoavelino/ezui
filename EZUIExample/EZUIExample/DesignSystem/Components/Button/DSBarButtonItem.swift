//
//  DSBarButtonItem.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 07/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSBarButtonItem: UIBarButtonItem {
    
    var actionType: DSActionType
    
    init(
        actionType: DSActionType,
        title: String?,
        style: Style = .plain,
        target: AnyObject? = nil,
        action: Selector? = nil
    ) {
        self.actionType = actionType
        super.init()
        self.title = title
        self.style = style
        self.target = target
        self.action = action
    }
    
    init(
        actionType: DSActionType,
        image: UIImage?,
        style: Style = .plain,
        target: AnyObject? = nil,
        action: Selector? = nil
    ) {
        self.actionType = actionType
        super.init()
        self.image = image
        self.style = style
        self.target = target
        self.action = action
    }
    
    @available(iOS 14.0, *)
    init(
        actionType: DSActionType,
        title: String?,
        style: Style = .plain,
        target: AnyObject? = nil,
        action: Selector? = nil,
        menu: UIMenu? = nil
    ) {
        self.actionType = actionType
        super.init()
        self.title = title
        self.style = style
        self.target = target
        self.action = action
        self.menu = menu
    }
    
    @available(iOS 14.0, *)
    init(
        actionType: DSActionType,
        image: UIImage?,
        style: Style = .plain,
        target: AnyObject? = nil,
        action: Selector? = nil,
        menu: UIMenu? = nil
    ) {
        self.actionType = actionType
        super.init()
        self.image = image
        self.style = style
        self.target = target
        self.action = action
        self.menu = menu
    }
    
    @available(iOS 14.0, *)
    init(
        actionType: DSActionType,
        image: UIImage?,
        menu: UIMenu? = nil
    ) {
        self.actionType = actionType
        super.init()
        self.image = image
        self.menu = menu
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
