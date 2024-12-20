//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by ulyana on 27.10.24.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping(Result<Data, Error>) -> Void)
}

struct NetworkClient: NetworkRouting {
    
    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping(Result<Data, Error>) -> Void) {
        
        // создаём запрос из url
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            // Проверяем, пришла ли ошибка
            if let erorr = error {
                handler(.failure(erorr))
                return
            }
            
            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse, response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            // Возвращаем данные
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}
