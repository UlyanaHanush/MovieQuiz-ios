//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by ulyana on 11.10.24.
//

import Foundation

// Определение пользовательских ошибок, связанных с фабрикой вопросов
enum QuestionFactoryError: Error {
    case loadImageError(String) // Ошибка загрузки изображения
}

/// хранение и обработка вопросов для квиза
final class QuestionFactory: QuestionFactoryProtocol {
    private weak var delegate: QuestionFactoryDelegate?
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    // сохраняем фильм в нашу новую переменную
                    self.movies = mostPopularMovies.items
                    // сообщаем, что данные загрузились
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    // сообщаем об ошибке нашему MovieQuizViewController
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    /// рандомный отбор вопроса для квиза
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            // Выбор случайного фильма из списка
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            self.loadImage(for: movie) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
                        let rating = Float(movie.rating) ?? 0
                        
                        let raitingNumber = (0...10).randomElement() ?? 0
                        let text = "Рейтинг этого фильма больше чем \(raitingNumber)?"
                        let correctAnswer = rating > Float(raitingNumber)
                        
                        let question = QuizQuestion(image: imageData,
                                                    text: text,
                                                    correctAnswer: correctAnswer)
                        self.delegate?.didReceiveNextQuestion(question: question)
                    case .failure(let error):
                        // Уведомление делегата об ошибке загрузки изображения
                        self.delegate?.didFailToLoadImage(with: error)
                    }
                }
            }
        }
    }
    
    func loadImage(for movie: MostPopularMovie, completion: @escaping (Result<Data, Error>) -> Void) {
            DispatchQueue.global().async {
                do {
                    let imageData = try Data(contentsOf: movie.resizedImageURL)
                    DispatchQueue.main.async {
                        completion(.success(imageData))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(QuestionFactoryError.loadImageError(error.localizedDescription)))
                    }
                }
            }
        }
    }

//    private let questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Dark Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Kill Bill",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Deadpool",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Old",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Tesla",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Vivarium",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false)
//    ]
