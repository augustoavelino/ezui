//
//  ColorPickerViewControllerDelegate.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 30/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol ColorPickerViewControllerDelegate: AnyObject {
    func colorPicker(_ colorPicker: ColorPickerViewController, didFinishWith color: UIColor, name colorName: String)
    func colorPickerDidCancel(_ colorPicker: ColorPickerViewController)
    func colorPicker(_ colorPicker: ColorPickerViewController, willDisappearAnimated animated: Bool)
}

extension ColorPickerViewControllerDelegate {
    func colorPicker(_ colorPicker: ColorPickerViewController, didFinishWith color: UIColor, name colorName: String) {}
    func colorPickerDidCancel(_ colorPicker: ColorPickerViewController) {}
    func colorPicker(_ colorPicker: ColorPickerViewController, willDisappearAnimated animated: Bool) {}
}
