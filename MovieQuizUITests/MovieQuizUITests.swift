//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by ulyana on 5.11.24.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        // откроет приложение
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        // закроет приложение
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        sleep(3)

        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap() // находим кнопку 'Да' и нажимаем ее
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] // еще раз находим постер
        
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        // текст лейбла соответствует значению 2/10
        XCTAssertEqual(indexLabel.label, "2/10")
        XCTAssertFalse(firstPosterData == secondPosterData) // проверяем что постеры разные
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap() // находим кнопку 'Нет' и нажимаем ее
        
        sleep(3)
        
        let secondPoster = app.images["Poster"] // еще раз находим постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(firstPosterData == secondPosterData) // проверяем что постеры разные
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() {
        sleep(3)
        
        for _ in 1...10 {
            app.buttons["No"].tap() // находим кнопку 'Нет' и нажимаем ее
            sleep(2)
        }
        
        let alert = app.alerts["Alert"] // находим первоначальный алерт
        
        XCTAssertTrue(alert.exists) // проверка наличия алерта
        
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
