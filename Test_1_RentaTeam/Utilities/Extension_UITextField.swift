//
//  Extension_UITextField.swift
//  TestAlef3
//
//  Created by Maksim Ponomarev on 01.11.2021.
//

import UIKit

extension UITextField {
    func addCancelButtonOnKeyboard() {
           let keyboardToolbar = UIToolbar()
           keyboardToolbar.sizeToFit()
           let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
               target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .cancel,
               target: self, action: #selector(resignFirstResponder))
           keyboardToolbar.items = [flexibleSpace, doneButton]
           self.inputAccessoryView = keyboardToolbar
       }
}
