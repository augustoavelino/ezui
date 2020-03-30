//
//  EZViewController.swift
//  EZUI
//
//  Created by Augusto Avelino on 01/02/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZViewController: UIViewController {
    /// The style of the status bar. This prop will only work if you have set the UIViewControllerBasedStatusBarAppearance key of your Info.plist to `true`.
    open var statusBarStyle: UIStatusBarStyle = .default {
        didSet { setNeedsStatusBarAppearanceUpdate() }
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapToEndEditing()
    }
    
    /// A place to invoke your views' setup methods.
    /// This method is called in `viewDidLoad`.
    open func setupUI() {}
    
    /// Adds a `UITapGestureRecognizer` to `view` to
    /// end any editing action.
    open func setupTapToEndEditing() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
