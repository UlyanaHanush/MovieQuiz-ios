//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by ulyana on 12.10.24.
//

import Foundation
import UIKit

final class AlertPresenter {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    // приватный метод для показа результатов раунда квиза
    // принимает вью модель QuizResultsViewModel и ничего не возвращает
    func show(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title, // заголовок всплывающего окна
            message: result.message, // текст во всплывающем окне
            preferredStyle: .alert) // preferredStyle может быть .alert или .actionSheet
        
        // создаём для алерта кнопку с действием
        // в замыкании пишем, что должно происходить при нажатии на кнопку
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            result.completion()

        }
        
        // добавляем в алерт кнопку
        alert.addAction(action)
        
        // показываем всплывающее окно
        viewController?.present(alert, animated: true, completion: nil)
    }
}
