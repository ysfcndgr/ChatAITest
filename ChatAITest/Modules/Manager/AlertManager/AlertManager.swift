//
//  AlertManager.swift
//  Capstone Project Cem
//
//  Created by Can on 13.06.2024.
//

import UIKit

protocol AlertShowable {
    func showAlert(with error: String, title: String, buttonTitle: String, action: @escaping () -> ()?)
}

final class AlertManager: AlertShowable {
    
    private init() { }
    
    static let shared: AlertManager = .init()
    
    func showAlert(with error: String, title: String, buttonTitle: String, action: @escaping () -> ()?) {
        let alert = UIAlertController(
            title: title,
            message: error.description,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { _ in
            action()
        }))

        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }
}
