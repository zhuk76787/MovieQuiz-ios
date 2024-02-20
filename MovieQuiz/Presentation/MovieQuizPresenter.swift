//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Жуков on 2/20/24.
//

import UIKit


final class MovieQuizPresenter: QuestionFactoryDelegate{
    
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var statisticService: StatisticServiceProtocol = StatisticServiceImplementation()
    
    let questionsAmount:Int = 10
    private var currentQuestionIndex:Int = 0
    var correctAnswers = 0
    var currentQuestion: QuizQuestion?
    
    
    
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hidenLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {return}
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer{ correctAnswers += 1}
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func makeResultMessage() -> String {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        let bestGame = statisticService.bestGame
        let gameResult = "Ваш результат: \(correctAnswers)/\(questionsAmount)"
        let quizCount = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let bestGameInfo = "Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))"
        let averageAccuracy = "Средняя точность: \(String(format: "%.0f%%", self.statisticService.totalAccuracy * 100))"
        let textMessage = [gameResult,
                           quizCount,
                           bestGameInfo,
                           averageAccuracy
        ].joined(separator: "\n")
        return textMessage
    }
    
    func proceedToNextQuestionOrResults() {
        if self.isLastQuestion() {
            let results = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: makeResultMessage(),
                buttonText: "Сыграть еще раз")
            viewController?.show(quiz: results)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
            viewController?.buttonEnable()
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.buttonUnenable()
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer == isYes)
    }
}
