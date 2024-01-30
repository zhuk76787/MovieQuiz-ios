//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 1/30/24.
//

import Foundation


protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}
