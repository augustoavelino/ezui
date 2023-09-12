//
//  TypographyViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 11/08/22.
//  Copyright © 2022 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class TypographyViewController: EZScrollViewController {
    
    // MARK: View model
    
    let viewModel: TypographyViewModelProtocol
    
    // MARK: UI
    
    let stackView = EZStackView(
        axis: .vertical,
        spacing: 16.0
    )
    
    // MARK: - Life cycle
    
    init(viewModel: TypographyViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = "Typography"
        view.backgroundColor = .systemBackground
        setupStackView()
        setupLabels()
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.layout {
            $0.top == contentView.topAnchor + 48.0
            $0.leading == contentView.leadingAnchor + 24.0
            $0.trailing == contentView.trailingAnchor - 24.0
            $0.bottom == contentView.bottomAnchor - 48.0
        }
    }
    
    private func setupLabels() {
        for label in viewModel.textData.map(makeLabel(withText:textStyle:)) {
            stackView.addArrangedSubview(label)
        }
    }
    
    private func makeLabel(withText text: String, textStyle: UIFont.TextStyle) -> UILabel {
        return EZDefaultLabel(
            text: text,
            textAlignment: .center,
            textStyle: textStyle
        )
    }
}
