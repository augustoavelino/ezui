//
//  ViewLayoutViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ViewLayoutViewController: DSLegacyViewController {
    
    // MARK: View model
    
    let viewModel: ViewLayoutViewModelProtocol
    
    // MARK: UI
    
    var constantReference: CGFloat {
        return (UIScreen.main.bounds.width - 32.0) / 2.0
    }
    
    lazy var stackView = EZStackView(
        axis: .vertical,
        spacing: 12.0,
        arrangedSubviews: [containerView, sliderBackgroundView]
    )
    
    lazy var containerView: UIView = {
        let container = UIView()
        container.borderColor = UIColor.systemFill.cgColor
        container.borderWidth = 0.5
        container.cornerRadius = 5.0
        container.layout {
            $0.height == container.widthAnchor
        }
        return container
    }()
    lazy var exampleView = ViewLayoutEzampleView()
    
    let sliderScrollView = UIScrollView()
    lazy var sliderBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .secondarySystemBackground
        backgroundView.cornerRadius = 5.0
        return backgroundView
    }()
    lazy var sliderStackView = EZStackView(
        axis: .vertical,
        spacing: 8.0,
        arrangedSubviews: [
            topSlider,
            DSSeparator(forOrientation: .vertical),
            leadingSlider,
            DSSeparator(forOrientation: .vertical),
            trailingSlider,
            DSSeparator(forOrientation: .vertical),
            bottomSlider,
        ]
    )
    lazy var topSlider: DSSliderView = {
        let sliderView = DSSliderView(
            title: "Top:",
            maximumValue: constantReference
        )
        sliderView.delegate = self
        return sliderView
    }()
    lazy var leadingSlider: DSSliderView = {
        let sliderView = DSSliderView(
            title: "Leading:",
            maximumValue: constantReference
        )
        sliderView.delegate = self
        return sliderView
    }()
    lazy var trailingSlider: DSSliderView = {
        let sliderView = DSSliderView(
            title: "Trailing:",
            maximumValue: constantReference
        )
        sliderView.delegate = self
        return sliderView
    }()
    lazy var bottomSlider: DSSliderView = {
        let sliderView = DSSliderView(
            title: "Bottom:",
            maximumValue: constantReference
        )
        sliderView.delegate = self
        return sliderView
    }()
    
    weak var topConstraint: NSLayoutConstraint?
    weak var leadingConstraint: NSLayoutConstraint?
    weak var trailingConstraint: NSLayoutConstraint?
    weak var bottomConstraint: NSLayoutConstraint?
    
    // MARK: - Life cycle
    
    init(viewModel: ViewLayoutViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = "View Layout"
        view.backgroundColor = .systemBackground
        setupStackView()
        setupSliderStackView()
        setupExampleView()
    }
    
    func setupScrollView() {
        view.addSubview(sliderScrollView)
        sliderScrollView.layoutFillSuperview()
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.layout {
            $0.top == view.safeAreaLayoutGuide.topAnchor + 16.0
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor - 16.0
            $0.leading == view.safeAreaLayoutGuide.leadingAnchor + 16.0
            $0.trailing == view.safeAreaLayoutGuide.trailingAnchor - 16.0
        }
    }
    
    func setupSliderStackView() {
        sliderBackgroundView.addSubview(sliderScrollView)
        sliderScrollView.layoutFillSuperview()
        sliderScrollView.addSubview(sliderStackView)
        sliderStackView.layout {
            $0.top == sliderScrollView.topAnchor + 16.0
            $0.bottom == sliderScrollView.bottomAnchor - 16.0
            $0.leading == sliderBackgroundView.leadingAnchor + 16.0
            $0.trailing == sliderBackgroundView.trailingAnchor - 16.0
        }
    }
    
    func setupExampleView() {
        containerView.addSubview(exampleView)
        exampleView.layout {
            topConstraint = $0.top == containerView.topAnchor + constantReference / 2.0
            bottomConstraint = $0.bottom == containerView.bottomAnchor - constantReference / 2.0
            leadingConstraint = $0.leading == containerView.leadingAnchor + constantReference / 2.0
            trailingConstraint = $0.trailing == containerView.trailingAnchor - constantReference / 2.0
        }
    }
}

// MARK: - DSSliderViewDelegate

extension ViewLayoutViewController: DSSliderViewDelegate {
    func sliderView(_ sliderView: DSSliderView, didChangeValueTo value: CGFloat) {
        if sliderView.isEqual(topSlider) {
            topConstraint?.constant = value
        } else if sliderView.isEqual(leadingSlider) {
            leadingConstraint?.constant = value
        } else if sliderView.isEqual(trailingSlider) {
            trailingConstraint?.constant = -value
        } else if sliderView.isEqual(bottomSlider) {
            bottomConstraint?.constant = -value
        }
    }
}
