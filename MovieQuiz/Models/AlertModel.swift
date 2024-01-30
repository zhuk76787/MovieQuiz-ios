//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 1/29/24.
//

import Foundation


struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    var buttonAction: (() -> Void)?
}
