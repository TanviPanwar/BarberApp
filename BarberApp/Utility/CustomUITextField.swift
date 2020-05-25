//
//  CustomUITextField.swift
//  BarberApp
//
//  Created by iOS6 on 22/05/20.
//  Copyright © 2020 iOS8. All rights reserved.
//

import Foundation
import UIKit 

class CustomUITextField: UITextField {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) {
            return false
        }

        return true
    }
}
