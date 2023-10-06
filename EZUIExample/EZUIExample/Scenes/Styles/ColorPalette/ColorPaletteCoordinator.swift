//
//  ColorPaletteCoordinator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 14/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

// MARK: - Routes

enum ColorPaletteRoute: EZRouteProtocol {
    case back
    case list
    case associatedList(projectID: String)
    case detail(palette: Palette)
    case createPalette(delegate: PaletteCreateAlertDelegate)
    case renamePalette(delegate: PaletteRenameAlertDelegate)
    case deletePalette(delegate: PaletteDeleteAlertDelegate)
    case exportPalette(items: [Any])
    case createColor(delegate: ColorPickerViewControllerDelegate)
    case editColor(color: PaletteColor, delegate: ColorPickerViewControllerDelegate)
    case deleteColor(delegate: PaletteDeleteAlertDelegate)
    
    var identifier: String {
        switch self {
        case .back: return "color_palette/back"
        case .list: return "color_palette/list"
        case .associatedList(let projectID): return "color_palette/list/\(projectID)"
        case .detail(let palette): return "color_palette/detail" + (palette.id ?? "unidentified")
        case .createPalette(_): return "color_palette/create_palette"
        case .renamePalette(_): return "color_palette/rename_palette"
        case .deletePalette(_): return "color_palette/delete_palette"
        case .exportPalette(_): return "color_palette/export_palette"
        case .createColor(_): return "color_palette/create_color"
        case .editColor(_, _): return "color_palette/edit_color"
        case .deleteColor(_): return "color_palette/delete_color"
        }
    }
}

// MARK: - Coordinator

protocol ColorPaletteCoordinatorProtocol: AnyObject {
    func performRoute(_ route: ColorPaletteRoute, animated: Bool)
}

class ColorPaletteCoordinator: DSCoordinator<ColorPaletteRoute>, ColorPaletteCoordinatorProtocol {
    
    // MARK: - Life cycle
    
    override func start(animated: Bool = true) {
        performRoute(.list, animated: animated)
    }
    
    // MARK: - Routing
    
    override func performRoute(_ route: ColorPaletteRoute, animated: Bool = true) {
        switch route {
        case .back: removeFromParent()
        case .list: presentList(animated: animated)
        case .associatedList(let projectID): presentAssociatedList(projectID: projectID, animated: animated)
        case .detail(let palette): presentDetail(palette: palette, animated: animated)
        case .createPalette(let delegate): presentCreateAlert(delegate: delegate)
        case .renamePalette(let delegate): presentRenameAlert(delegate: delegate)
        case .deletePalette(let delegate): presentDeleteAlert(delegate: delegate)
        case .exportPalette(let items): presentExportController(items: items, animated: animated)
        case .createColor(let delegate): presentCreateColorPicker(delegate: delegate, animated: animated)
        case .editColor(let color, let delegate): presentEditColorPicker(color: color, delegate: delegate, animated: animated)
        case .deleteColor(let delegate): presentDeleteColorAlert(delegate: delegate)
        }
    }
    
    func presentList(animated: Bool) {
        let repository = ColorPaletteListRepository()
        let viewModel = ColorPaletteListViewModel(repository: repository, coordinator: self)
        let viewController = ColorPaletteListViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        push(viewController, animated: animated)
    }
    
    func presentAssociatedList(projectID: String, animated: Bool) {
        let repository = ProjectPalettePickerRepository(projectID: projectID)
        let viewModel = ColorPaletteListViewModel(repository: repository, coordinator: self)
        let viewController = ColorPaletteListViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        push(viewController, animated: animated)
    }
    
    func presentDetail(palette: Palette, animated: Bool) {
        let repository = ColorPaletteDetailRepository(palette: palette)
        let viewModel = ColorPaletteDetailViewModel(repository: repository, coordinator: self)
        let viewController = ColorPaletteDetailViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        push(viewController, animated: animated)
    }
    
    func presentCreateAlert(delegate: PaletteCreateAlertDelegate) {
        // TODO: Corrigir apresentação de alerts
//        presentStatefulTextFieldAlert(
//            title: "New Color Palette",
//            message: "Choose a name",
//            textFieldPlaceholder: "Ex: Background",
//            actionBuilder: { alert, textField in
//                return UIAlertAction(title: "Create", style: .default) { [weak delegate, weak alert, weak textField] _ in
//                    guard let delegate = delegate,
//                          let alert = alert,
//                          let textField = textField else { return }
//                    delegate.alert(alert, didCreateWith: textField.text)
//                }
//            },
//            cancelHandler: { [weak delegate] alert in
//                guard let delegate = delegate else { return }
//                delegate.alertDidCancel(alert)
//            }
//        )
    }
    
    func presentRenameAlert(delegate: PaletteRenameAlertDelegate) {
        // TODO: Corrigir apresentação de alerts
//        presentStatefulTextFieldAlert(
//            title: "Rename Color Palette",
//            message: "Choose a new name",
//            textFieldText: delegate.currentTextFieldText(),
//            textFieldPlaceholder: "Ex: Background",
//            actionBuilder: { alert, textField in
//                return UIAlertAction(title: "Confirm", style: .default) { [weak delegate, weak alert, weak textField] _ in
//                    guard let delegate = delegate,
//                          let alert = alert,
//                          let textField = textField else { return }
//                    delegate.alert(alert, didRenameWith: textField.text)
//                }
//            },
//            cancelHandler: { [weak delegate] alert in
//                guard let delegate = delegate else { return }
//                delegate.alertDidCancel(alert)
//            }
//        )
    }
    
    func presentDeleteAlert(delegate: PaletteDeleteAlertDelegate) {
        // TODO: Corrigir apresentação de alerts
//        presentAlert(
//            title: "Delete Color Palette",
//            message: "Are you sure you want to proceed?",
//            actionBuilder: { alert in
//                return UIAlertAction(title: "Delete", style: .destructive) { [weak delegate, weak alert] _ in
//                    guard let delegate = delegate,
//                          let alert = alert else { return }
//                    delegate.alertDidConfirmDeletion(alert)
//                }
//            },
//            cancelHandler: { [weak delegate] alert in
//                guard let delegate = delegate else { return }
//                delegate.alertDidCancel(alert)
//            }
//        )
    }
    
    func presentExportController(items: [Any], animated: Bool) {
        let activity = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activity, animated: animated)
    }
    
    func presentCreateColorPicker(delegate: ColorPickerViewControllerDelegate, animated: Bool) {
        let colorPicker = ColorCreatorViewController()
        colorPicker.delegate = delegate
        present(UINavigationController(rootViewController: colorPicker), animated: animated)
    }
    
    func presentEditColorPicker(color: PaletteColor, delegate: ColorPickerViewControllerDelegate, animated: Bool) {
        let colorPicker = ColorEditorViewController(name: color.name ?? "Untitled", hexValue: Int(color.colorHex))
        colorPicker.delegate = delegate
        present(UINavigationController(rootViewController: colorPicker), animated: animated)
    }
    
    func presentDeleteColorAlert(delegate: PaletteDeleteAlertDelegate) {
        // TODO: Corrigir apresentação de alerts
//        presentAlert(
//            title: "Delete Color",
//            message: "Are you sure you want to proceed?",
//            actionBuilder: { alert in
//                return UIAlertAction(title: "Delete", style: .destructive) { [weak delegate, weak alert] _ in
//                    guard let delegate = delegate,
//                          let alert = alert else { return }
//                    delegate.alertDidConfirmDeletion(alert)
//                }
//            },
//            cancelHandler: { [weak delegate] alert in
//                guard let delegate = delegate else { return }
//                delegate.alertDidCancel(alert)
//            }
//        )
    }
}
