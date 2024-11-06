//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by ulyana on 12.10.24.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    
    //func didLoadImage()
    func didFailToLoadImage(with error: Error)
}
