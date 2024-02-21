//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 1/29/24.
//

import Foundation


protocol AlertPresenterProtocol: AnyObject {
    var delegate: AlertPresenterDelegate? {get set}
    func show(alertModel: AlertModel)
}
