//
//  Float + Extensions.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 2/7/24.
//

import Foundation


extension Float {
    static var randomMovieRating: Float {
        let randomFloat = Float.random(in: 1.0...10.0)
        let intVal:Int = Int(randomFloat*10)
        return Float(intVal)/10.0
    }
}
