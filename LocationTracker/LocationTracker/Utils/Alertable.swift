//
//  Alertable.swift
//  LocationTracker
//
//  Created by Aise Nur Mor on 22.03.2025.
//

import UIKit

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?
    
    init(
        title: String,
        style: UIAlertAction.Style,
        handler: (() -> Void)? = nil
    ) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

protocol Alertable { }

extension Alertable where Self : UIViewController {
    
    func showAlert(
        with title: String,
        message: String,
        actions: [AlertAction]? = nil
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions {
            actions.forEach { action in
                alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: { _ in
                    if let handler = action.handler {
                        handler()
                    } else {
                        alertController.dismiss(animated: true)
                    }
                }))
            }
        } else {
            alertController.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                alertController.dismiss(animated: true, completion: nil)
            }))
        }
        present(alertController, animated: true, completion: nil)
    }
}
