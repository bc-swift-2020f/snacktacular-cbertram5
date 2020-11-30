//
//  UIBarButtonItem+hide.swift
//  Snacktacular
//
//  Created by Chris Bertram on 11/11/20.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
