//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by ulyana on 12.10.24.
//

import Foundation
import UIKit

/// создание аллерта и отображение
final class AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    /// приватный метод для показа результатов раунда квиза
    func presentAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title, // заголовок всплывающего окна
            message: model.message, // текст во всплывающем окне
            preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        alert.view.accessibilityIdentifier = "Alert"
        
        // создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()

        }
        
        // добавляем в алерт кнопку
        alert.addAction(action)
        
        // показываем всплывающее окно
        viewController?.present(alert, animated: true, completion: nil)
    }
}
