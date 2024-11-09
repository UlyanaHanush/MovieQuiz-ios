import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    private var alertPresenter: AlertPresenter?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        
        // показываем индикатор загрузки
        showLoadingIndicator()
        
        alertPresenter = AlertPresenter(viewController: self)
        
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - AlertPresenter
    
    /// показ алерта
    func show(quiz result: AlertModel) {
        alertPresenter?.presentAlert(with: result)
    }
    
    // MARK: - Public Methods
    
    /// приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        // включение кнопки ответа
        changeStateButtons(isEnabled: true)
        imageView.layer.borderColor = UIColor.clear.cgColor
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    
    /// скрываем индикатор загрузки
    func hideLoadingIndicator() {
        // выключаем анимацию
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
        }
    }
    
    /// индикатор загрузки
    func showLoadingIndicator() {
        // включаем анимацию
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        //  блокировка кнопки ответа
        changeStateButtons(isEnabled: false)
    }
    
    /// состояние ошибки
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.imageView.layer.borderColor = UIColor.clear.cgColor
                // включение кнопки ответа
                self.changeStateButtons(isEnabled: true)
                // загружаем вопросы
                self.presenter.restartGame()
            }
        
        
        show(quiz: model)
    }
    
    func showImageError(message: String) {
        let model = AlertModel(
            title: "Ошибка",
            message: "Не удалось загрузить картинку",
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                presenter.restartGame()
            }
        
        
        show(quiz: model)
    }
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Private Methods
    
    /// изменение состояния кнопки
    private func changeStateButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
}
