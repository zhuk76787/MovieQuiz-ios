import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    private var alertPresenter: AlertPresenterProtocol?
    private let presenter = MovieQuizPresenter()
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        
        alertPresenter = AlertPresenter(delegate: self)
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        presenter.statisticService = StatisticServiceImplementation()
        
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
        
        super.viewDidLoad()
        presenter.viewController = self
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func show(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        questionLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText,
            buttonAction: {[weak self] in
                guard let self = self else {return}
                self.presenter.resetQuestionIndex()
                self.presenter.correctAnswers = 0
                self.noButton.isEnabled = true
                self.yesButton.isEnabled = true
                self.presenter.questionFactory?.requestNextQuestion()
            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect { presenter.correctAnswers += 1 }
        let borderColor = isCorrect ? UIColor.ypGreen : UIColor.ypRed
        noButton.isEnabled = false
        yesButton.isEnabled = false
        imageView.layer.borderColor = borderColor.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {[weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            
            self.presenter.resetQuestionIndex()
            self.presenter.correctAnswers = 0
            
            self.presenter.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.show(alertModel: model)
        
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        presenter.questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
}

