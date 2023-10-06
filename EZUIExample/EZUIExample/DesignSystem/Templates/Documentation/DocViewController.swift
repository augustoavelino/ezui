//
//  DocViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DocViewController: DSLegacyViewController {
    
    // MARK: View model
    
    let viewModel: DocViewModelProtocol
    
    // MARK: UI
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.textContainerInset = UIEdgeInsets(
            top: 20.0,
            left: 16.0,
            bottom: 0.0,
            right: 16.0
        )
        return textView
    }()
    
    // MARK: - Life cycle
    
    init(viewModel: DocViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = "Documentation"
        setupNavigationItem()
        setupTextView()
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }
    
    private func setupTextView() {
        textView.attributedText = viewModel.documentation.attributedString
        view.addSubview(textView)
        textView.layoutFillSuperview()
    }
    
    @objc func didTapCloseButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
}
