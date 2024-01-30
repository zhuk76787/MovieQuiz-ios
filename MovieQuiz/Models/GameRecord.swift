//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 1/30/24.
//

import Foundation


struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan (_ another: GameRecord) -> Bool{
        correct > another.correct
    }
}
