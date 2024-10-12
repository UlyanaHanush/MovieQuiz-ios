//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by ulyana on 12.10.24.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
