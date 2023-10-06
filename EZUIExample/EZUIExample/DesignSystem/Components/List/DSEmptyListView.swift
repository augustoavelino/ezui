//
//  DSEmptyListView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 29/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSEmptyListView: EZView {
    
    // MARK: UI
    
    private lazy var stackView = EZStackView(
        axis: .vertical,
        alignment: .center,
        spacing: 8.0,
        arrangedSubviews: [imageView, label]
    )
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemFill
        imageView.layout {
            let imageSize: CGFloat = 64.0
            $0.width == imageSize
            $0.height == imageSize
        }
        return imageView
    }()
    private lazy var label = DSLabel(
        textStyle: .title2,
        textColor: .secondaryLabel
    )
    
    // MARK: - Life cycle
    
    init(
        image: UIImage? = UIImage(systemName: "xmark.bin.fill")?.applyingSymbolConfiguration(.init(weight: .light)),
        text: String? = "Collection is empty"
    ) {
        super.init(frame: .zero)
        imageView.image = image
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        addSubview(stackView)
        stackView.layout {
            $0.centerY == centerYAnchor
            $0.leading == leadingAnchor + 16.0
            $0.trailing == trailingAnchor - 16.0
        }
    }
}
