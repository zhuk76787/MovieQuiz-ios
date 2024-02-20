import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate,MovieQuizViewControllerProtocol {
   
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter:MovieQuizPresenter!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        alertPresenter = AlertPresenter(delegate: self)
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController:self)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
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
                self.presenter.restartGame()
                self.buttonEnable()           }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    func buttonEnable() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func buttonUnenable() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hidenLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        activityIndicator.isHidden = true
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else {return}
            
            self.presenter.restartGame()
        }
        alertPresenter?.show(alertModel: model)
        
    }
}

