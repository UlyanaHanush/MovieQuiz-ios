//
//  GameResult.swift
//  MovieQuiz
//
//  Created by ulyana on 15.10.24.
//

import Foundation
/// структура для подсчета статистики  -> отображение в алерте
struct GameResult {
    /// количество правильных ответов
    let correct: Int
    /// общее количество вопросов
    let total: Int
    /// дата сыгранного квиза
    let date: Date
    
    /// функция проверяет лучший результат игры
    func isBetterThan(_ another:GameResult) -> Bool {
        correct > another.correct
    }
}
