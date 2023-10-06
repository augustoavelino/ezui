//
//  DSViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSLegacyViewController: EZViewController {
    
    // MARK: Properties
    
    fileprivate var activityIndicators: [UIActivityIndicatorView] {
        return view.subviews.compactMap({ $0 as? UIActivityIndicatorView })
    }
    
    fileprivate var hasActivityIndicator: Bool {
        return !activityIndicators.isEmpty
    }
    
    // MARK: - Life cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        presentedViewController?.dismiss(animated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Activity indicator
    
    func displayActivityIndicator() {
        guard !hasActivityIndicator else { return }
        let indicator = UIActivityIndicatorView(style: .large)
        view.addSubview(indicator)
        indicator.layout {
            $0.centerX == view.safeAreaLayoutGuide.centerXAnchor
            $0.centerY == view.safeAreaLayoutGuide.centerYAnchor
        }
        indicator.startAnimating()
    }
    
    func dismissAcitivityIndicators() {
        DispatchQueue.main.async {
            self.activityIndicators.forEach {
                $0.stopAnimating()
                $0.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Alert
    
    func presentAlert(
        title: String?,
        message: String? = nil,
        animated: Bool = true,
        configurationHandler: @escaping (UIAlertController) -> Void,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        configurationHandler(alert)
        present(alert, animated: animated, completion: completion)
    }
    
    func presentAlertWithTextField(
        title: String?,
        message: String? = nil,
        textFieldText: String? = nil,
        textFieldPlaceholder: String? = nil,
        animated: Bool = true,
        configurationHandler: ((UIAlertController, UITextField) -> Void)? = nil,
        completion: (() -> Void)? = nil
    ) {
        presentAlert(title: title, message: message, configurationHandler: { alert in
            alert.addTextField { [weak alert] textField in
                guard let configurationHandler = configurationHandler,
                      let alert = alert else { return }
                textField.text = textFieldText
                textField.placeholder = textFieldPlaceholder
                configurationHandler(alert, textField)
            }
        }, completion: completion)
    }
    
    func presentErrorAlert(title: String = "error", message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Action sheet
    
    func presentActionSheet(
        title: String?,
        message: String? = nil,
        animated: Bool = true,
        configurationHandler: @escaping (UIAlertController) -> Void,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        configurationHandler(alert)
        present(alert, animated: animated, completion: completion)
    }
    
    // MARK: - Building helpers
    
    func makeBarButton(
        title: String,
        style: UIBarButtonItem.Style = .plain,
        action: Selector
    ) -> UIBarButtonItem {
        return UIBarButtonItem(
            title: title,
            style: style,
            target: self,
            action: action
        )
    }
    
    func makeBarButton(
        iconName: String,
        style: UIBarButtonItem.Style = .plain,
        action: Selector
    ) -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: iconName),
            style: style,
            target: self,
            action: action
        )
    }
    
    func makeSystemBarButton(
        _ systemItem: UIBarButtonItem.SystemItem,
        action: Selector
    ) -> UIBarButtonItem {
        return UIBarButtonItem(
            barButtonSystemItem: systemItem,
            target: self,
            action: action
        )
    }
}

class DSViewController<ViewModel: DSViewModelProtocol>: DSLegacyViewController {
    
    // MARK: Properties
    
    let viewModel: ViewModel
    
    // MARK: - Life cycle
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapBarButton(_ sender: DSBarButtonItem) {
        guard let actionType = sender.actionType as? ViewModel.ActionType else { return }
        viewModel.performAction(actionType)
    }
    
    // MARK: - Building helpers
    
    func makeAction(
        _ actionType: ViewModel.ActionType,
        title: String,
        iconName: String? = nil,
        identifier: UIAction.Identifier? = nil,
        discoverabilityTitle: String? = nil,
        attributes: UIMenuElement.Attributes = [],
        state: UIMenuElement.State = .off,
        completion: ((UIAction) -> Void)? = nil
    ) -> UIAction {
        var buttonImage: UIImage?
        if let iconName = iconName {
            if let image = UIImage(named: iconName) {
                buttonImage = image
            } else if let image = UIImage(systemName: iconName) {
                buttonImage = image
            }
        }
        return UIAction(
            title: title,
            image: buttonImage,
            identifier: identifier,
            discoverabilityTitle: discoverabilityTitle,
            attributes: attributes,
            state: state,
            handler: { [weak self] action in
                guard let self = self else { return }
                self.viewModel.performAction(actionType)
                completion?(action)
            }
        )
    }
    
    func makeAlertAction(
        _ action: ViewModel.ActionType,
        title: String,
        style: UIAlertAction.Style = .default,
        completion: (() -> Void)? = nil
    ) -> UIAlertAction {
        return UIAlertAction(title: title, style: style) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.performAction(action)
            completion?()
        }
    }
    
    func makeContextualAction(
        _ actionType: ViewModel.ActionType,
        style: UIContextualAction.Style = .normal,
        title: String? = nil,
        iconName: String? = nil,
        backgroundColor: UIColor? = nil
    ) -> UIContextualAction {
        let action = UIContextualAction(
            style: style, title: title
        ) { [weak self] _, _, completion in
            guard let self = self else { return }
            self.viewModel.performAction(actionType)
            completion(true)
        }
        if let iconName = iconName {
            action.image = UIImage(systemName: iconName)
        }
        action.backgroundColor = backgroundColor
        return action
    }
    
    func makeMenu(
        title: String = "",
        subtitle: String? = nil,
        image: UIImage? = nil,
        identifier: UIMenu.Identifier? = nil,
        options: UIMenu.Options = [],
        childrenBuilder: @escaping (UIMenu) -> [UIMenuElement]
    ) -> UIMenu {
        let menu = UIMenu(
            title: title,
            image: image,
            identifier: identifier,
            options: options
        )
        if #available(iOS 15.0, *) {
            menu.subtitle = subtitle
        }
        return menu.replacingChildren(childrenBuilder(menu))
    }
    
    func makeBarButton(
        _ actionType: ViewModel.ActionType,
        title: String,
        style: UIBarButtonItem.Style = .plain
    ) -> UIBarButtonItem {
        return DSBarButtonItem(
            actionType: actionType,
            title: title,
            style: style,
            target: self,
            action: #selector(didTapBarButton)
        )
    }
    
    func makeBarButton(
        _ actionType: ViewModel.ActionType,
        iconName: String,
        style: UIBarButtonItem.Style = .plain
    ) -> UIBarButtonItem {
        return DSBarButtonItem(
            actionType: actionType,
            image: UIImage(systemName: iconName),
            style: style,
            target: self,
            action: #selector(didTapBarButton)
        )
    }
    
    @available(iOS 14.0, *)
    func makeBarButton(
        _ actionType: ViewModel.ActionType,
        iconName: String,
        style: UIBarButtonItem.Style = .plain,
        menu: UIMenu? = nil
    ) -> UIBarButtonItem {
        return DSBarButtonItem(
            actionType: actionType,
            image: UIImage(systemName: iconName),
            style: style,
            target: self,
            action: #selector(didTapBarButton),
            menu: menu
        )
    }
    
    @available(iOS 14.0, *)
    func makeBarButton(
        _ actionType: ViewModel.ActionType,
        iconName: String,
        menu: UIMenu? = nil
    ) -> UIBarButtonItem {
        return DSBarButtonItem(
            actionType: actionType,
            image: UIImage(systemName: iconName),
            target: self,
            action: #selector(didTapBarButton),
            menu: menu
        )
    }
    
    @available(iOS 14.0, *)
    func makeBarButton(
        iconName: String,
        menu: UIMenu? = nil
    ) -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: iconName),
            menu: menu
        )
    }
}
