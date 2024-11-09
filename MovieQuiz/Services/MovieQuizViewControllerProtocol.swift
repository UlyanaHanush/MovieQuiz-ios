//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by ulyana on 9.11.24.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: AlertModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    func showImageError(message: String)
}
