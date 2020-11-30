//
//  UIViewController+alert.swift
//  ToDo List
//
//  Created by Chris Bertram on 10/1/20.
//  Copyright © 2020 Chris Bertram. All rights reserved.
//

import UIKit

extension UIViewController {
    func onebuttonAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
