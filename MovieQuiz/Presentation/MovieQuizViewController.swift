import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertProtocol {
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    
    /// общее количество вопросов для квиза
    private let questionsAmount: Int = 10
    /// фабрика вопросов
    private var questionFactory: QuestionFactoryProtocol?
    /// вопрос, который видит пользователь
    private var currentQuestion: QuizQuestion?
    /// переменная с индексом текущего вопроса, начальное значение 0
    /// (по этому индексу будем искать вопрос в массиве, где индекс первого элемента 0, а не 1)
    private var currentQuestionIndex = 0
    /// переменная со счётчиком правильных ответов, начальное значение закономерно 0
    private var correctAnswers = 0
    /// алерт
    private var alertPresenter: AlertPresenter?
    /// статистика
    private var statisticService: StatisticServiceProtocol!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        imageView.layer.cornerRadius = 20
        
        // показываем индикатор загрузки
        showLoadingIndicator()
        questionFactory?.loadData()
        
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticService()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertProtocol
    
    /// показ алерта
    func show(quiz result: AlertModel) {
        alertPresenter?.show(quiz: result)
    }
    
    // MARK: - QuestionFactoryDelegate
    
    /// данные с сервера загружены
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    ///  ошибка при загрузке данных с сервера
    func didFailToLoadData(with error: Error) {
        // возьмём в качестве сообщения описание ошибки
        showNetworkError(message: error.localizedDescription)
    }
    
    // MARK: - IBAction
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // MARK: - Private Methods
    
    /// приватный метод конвертации, который принимает моковый вопрос и возвращает вью модель для главного экрана
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text, // 3
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    /// приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    private func show(quiz step: QuizStepViewModel) {
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.text = step.question
    }
    /// приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        //  блокировка кнопки ответа
        changeStateButtons(isEnabled: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return } // разворачиваем слабую ссылку
            self.showNextQuestionOrResults()
        }
    }
    
    /// приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            // сохраняем статистику
            storeGameStatistics()
            // идём в состояние "Результат квиза"
            let text = """
                Ваш результат: \(correctAnswers)/10
                Количество сыгранных квизов: \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                """
            let alertModel = AlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз") { [weak self] in
                    self?.currentQuestionIndex = 0
                    self?.correctAnswers = 0
                    self?.imageView.layer.borderColor = UIColor.clear.cgColor
                    // включение кнопки ответа
                    self?.changeStateButtons(isEnabled: true)
                    // заново показываем первый вопрос
                    self?.questionFactory?.requestNextQuestion()
                }
            
            
            show(quiz: alertModel)
        } else {
            currentQuestionIndex += 1
            imageView.layer.borderColor = UIColor.clear.cgColor
            // включение кнопки ответа
            changeStateButtons(isEnabled: true)
            
            // идём в состояние "Вопрос показан"
            questionFactory?.requestNextQuestion()
        }
    }
    
    /// изменение состояния кнопки
    private func changeStateButtons(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    /// сохранение статистики
    private func storeGameStatistics() {
        statisticService.store(correct: correctAnswers, total: questionsAmount)
    }
    
    /// скрываем индикатор загрузки
    private func hideLoadingIndicator() {
        // говорим, что индикатор загрузки скрыт
        activityIndicator.isHidden = true
        // выключаем анимацию
        activityIndicator.stopAnimating()
    }
    
    /// индикатор загрузки
    private func showLoadingIndicator() {
        // говорим, что индикатор загрузки не скрыт
        activityIndicator.isHidden = false
        // включаем анимацию
        activityIndicator.startAnimating()
        
    }
    
    /// состояние ошибки
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        let model = AlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать ещё раз") { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.imageView.layer.borderColor = UIColor.clear.cgColor
                // включение кнопки ответа
                self.changeStateButtons(isEnabled: true)
                // заново показываем первый вопрос
                self.questionFactory?.requestNextQuestion()
            }
        
        
        show(quiz: model)
    }
}
