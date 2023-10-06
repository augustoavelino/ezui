//
//  ColorPaletteCoordinator+Palette.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 07/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol PaletteAlertDelegate: AnyObject {
    func alertDidCancel(_ alert: UIAlertController)
}

extension PaletteAlertDelegate {
    func alertDidCancel(_ alert: UIAlertController) {}
}

protocol PaletteCreateAlertDelegate: PaletteAlertDelegate {
    func alert(_ alert: UIAlertController, didCreateWith paletteName: String?)
}

protocol PaletteRenameAlertDelegate: PaletteAlertDelegate {
    func currentTextFieldText() -> String?
    func alert(_ alert: UIAlertController, didRenameWith paletteName: String?)
}

protocol PaletteDeleteAlertDelegate: PaletteAlertDelegate {
    func alertDidConfirmDeletion(_ alert: UIAlertController)
}
