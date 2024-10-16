//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by ulyana on 12.10.24.
//

import Foundation

/// структура для показа алерта
struct AlertModel {
    /// текст заголовка алерта
    var title: String
    /// текст сообщения алерта
    var message: String
    /// текст для кнопки алерта
    var buttonText: String
    /// замыкание без параметров для действия по кнопке алерта
    var completion: (() -> Void)
}
