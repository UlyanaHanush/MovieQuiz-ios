//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by ulyana on 15.10.24.
//

import Foundation
protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
