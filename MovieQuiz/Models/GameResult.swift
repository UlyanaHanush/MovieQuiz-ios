//
//  GameResult.swift
//  MovieQuiz
//
//  Created by ulyana on 15.10.24.
//

import Foundation
struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another:GameResult) -> Bool {
        correct > another.correct
    }
}
