//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by ulyana on 15.10.24.
//

import Foundation

/// сохранение и подсчет статистики квиза
final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum Keys {
        static let gamesCount = "gamesCount"
        static let bestGameCorrect = "bestGameCorrect"
        static let bestGameTotal = "bestGameTotal"
        static let bestGameDate = "bestGameDate"
        static let correctAnswer = "correctAnswer"
        static let totalAccuracy = "totalAccuracy"
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount)
        }
    }
    
    var bestGame: GameResult {
        get {
            // чтение значений полей GameResult(correct, total и date) из UserDefaults
            let correct = storage.integer(forKey: Keys.bestGameCorrect)
            let total =  storage.integer(forKey: Keys.bestGameTotal)
            let date = storage.object(forKey: Keys.bestGameDate) as? Date ?? Date()
            // GameResult от полученных значений
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect)
            storage.set(newValue.total, forKey: Keys.bestGameTotal)
            storage.set(newValue.date, forKey: Keys.bestGameDate)
        }
    }
    
    private var correctAnswers: Int {
        get {
            return storage.integer(forKey: Keys.correctAnswer)
        }
        set {
            storage.set(newValue, forKey: Keys.correctAnswer)
        }
    }
    
    var totalAccuracy: Double {
        get {
            return storage.double(forKey: Keys.totalAccuracy)
        }
        set {
            storage.set(newValue, forKey: Keys.totalAccuracy)
        }
    }
    
    /// обновление результатов после очередного квиза
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        
        correctAnswers += count
        
        guard gamesCount != 0 else { return }
        totalAccuracy = (Double(correctAnswers) / (Double(amount) * Double(gamesCount))) * 100
        
        let newResult = GameResult(correct: count, total: amount, date: Date())
        if newResult.isBetterThan(bestGame) {
            bestGame = newResult
        }
    }
}
