//
//  MainPresenterTest.swift
//  CurrencyConverterTests
//
//  Created by milan.mia on 5/19/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class MainPresenterTest: XCTestCase {

    let view = MainViewMock()
    let interactor = MainInteractorMock()
    let router = MainRouterMock()
    var presenter: MainPresenter!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        presenter = MainPresenter.init(view: view, router: router, interactor: interactor)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchData() {
        XCTContext.runActivity(named: "Fetch Test") { _ in
            XCTContext.runActivity(named: "Fetch Live Data") { _ in
                view.initialize()
                presenter.fetchQuotes()
                XCTAssertTrue(interactor.isFetched, "Fetching data successful.")
                XCTAssertTrue(view.isFetched, "UI update on fetch data successful.")
            }
            XCTContext.runActivity(named: "Converter Pass Test") { _ in
                view.initialize()
                presenter.fetchRateFor(from: "USD", to: "GBP", amount: 10)
                XCTAssertEqual(view.conversionString, "= 6.58443 GBP")
            }
            XCTContext.runActivity(named: "Converter Fail Test") { _ in
                view.initialize()
                presenter.fetchRateFor(from: "USD", to: "AED", amount: 10)
                XCTAssertNotEqual(view.conversionString, "= 6.58443 GBP")
                XCTAssertFalse(interactor.isConverted, "Conversion failed. Alert shown.")
            }
        }
        XCTContext.runActivity(named: "Alert") { _ in
            presenter.showAlert(title: "Info", message: "Fetch currency failed.", actionHandler: {})
            XCTAssertTrue(router.isShowAlert, "OK")
        }
    }

}

class MainViewMock: MainView {
    
    var isFetched: Bool!
    var isError: Bool!
    var conversionString:String!
    
    var currencyData: Currency? = nil {
        didSet {
            self.updateQuotes()
        }
    }
    
    init() {
        initialize()
    }

    func initialize() {
        isFetched = false
        isError = false
        conversionString = ""
    }

    func onError(error: CurrencyError) {
        isError = true
    }
    
    func didReceivedConversion(quote: String) {
        conversionString = quote
    }
    
    func didReceivedQuotes(currency: Currency) {
        currencyData = currency
    }
    
    func showPicker() {
        
    }
    
    func hidePicker() {
        
    }
    
    func updateQuotes(){
        isFetched = true
    }
}

class MainInteractorMock: MainUseCase {
    
    var isFetched = false
    var isConverted = false
    
    func requestRecentQuotes(completionHandler: @escaping CurConvResultHandler) {
        do {
            let jsonData = try Data(contentsOf: R.file.liveJson()!)
            completionHandler(.success(jsonData))
            isFetched = true
        }catch {
            completionHandler(.failure(CurrencyError.fetchCurrencyFailed))
            isFetched = false
        }
    }
    
    func requestQuote(from: String, to: String, amount: Double, completionHandler: @escaping CurConvResultHandler) {
        if from == "USD" && to == "GBP" {
            do {
                let jsonData = try Data(contentsOf: R.file.convertedJson()!)
                completionHandler(.success(jsonData))
                isConverted = true
            }catch {
                completionHandler(.failure(CurrencyError.fetchCurrencyFailed))
                isConverted = false
            }
        }else {
            completionHandler(.failure(CurrencyError.fetchCurrencyFailed))
            isConverted = false
        }
    }
    
    func requestSavedQuotes() -> Currency? {
        let currencyRM = CurrencyRealm.getCurrency()
        if currencyRM?.asDomain() != nil {
            isFetched = true
        }
        return currencyRM?.asDomain()
    }
}

class MainRouterMock: MainWireframe {

    var isShowAlert: Bool = false
    
    func routeToAlert(title: String, message: String, actionHandler: @escaping () -> Void) {
        isShowAlert = true
    }
}
