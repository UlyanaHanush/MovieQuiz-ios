//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by ulyana on 9.11.24.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    
    // MARK: - Private Properties
    
    /// общее количество вопросов для квиза
    let questionsAmount: Int = 10
    /// переменная с индексом текущего вопроса, начальное значение 0
    private var currentQuestionIndex: Int = 0
    
    // MARK: - MovieQuizViewController
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
        
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
        
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    /// приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }

}
