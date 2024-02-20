//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 2/20/24.
//

import UIKit


protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func buttonEnable()
    func buttonUnenable()
    
    func showLoadingIndicator()
    func hidenLoadingIndicator()
    
    func showNetworkError(message: String)
}
