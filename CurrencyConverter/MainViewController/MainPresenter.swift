//
//  MainPresenter.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/17/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Foundation
import RealmSwift

/// protocol Main Presentation
protocol MainPresentation {
    func viewDidLoad()
    func showPicker()
    func hidePicker()
    func retryFetch()
    func fetchRateFor(from:String, to:String, amount:Double)
    func showAlert(title: String, message: String, actionHandler: @escaping () -> Void)
}

/// Main Presenter
internal final class MainPresenter {

    private weak var view: MainView?
    private let router: MainWireframe
    private let interactor: MainUseCase

    init(view: MainView, router: MainWireframe, interactor: MainUseCase) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }

}

// MARK: - MainPresentation

extension MainPresenter: MainPresentation {
    
    func viewDidLoad() {
        fetchQuotes()
    }
    
    func retryFetch() {
        fetchQuotes()
    }
    
    func fetchQuotes() {
        view?.showHud()
        guard let currency:Currency = interactor.requestSavedQuotes() else {
            fetchFromServer()
            return
        }
        if currency.lastUpdate < Date() {
            fetchFromServer()
            return
        }
        view?.didReceivedQuotes(currency: currency)
    }
    
    func fetchFromServer() {
        interactor.requestRecentQuotes(completionHandler: { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let currency = try JSONDecoder().decode(CurrencyRealm.self, from: data)
                    currency.save()
                    self?.view?.didReceivedQuotes(currency: currency.asDomain())
                }catch {
                    self?.view?.onError(error: .quotesJsonDecodeFailed)
                }
            case .failure:
                self?.view?.onError(error: .fetchCurrencyFailed)
            }
        })
    }
    
    func fetchRateFor(from: String, to: String, amount: Double) {
        view?.showHud()
        interactor.requestQuote(from: from, to: to, amount: amount) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let conversion = try JSONDecoder().decode(Convert.self, from: data)
                    self?.view?.didReceivedConversion(quote: "= \(conversion.result) \(to)")
                }catch {
                    self?.calculateLocally(from: from, to: to, amount: amount)
                }
            case .failure:
                self?.calculateLocally(from: from, to: to, amount: amount)
            }
        }
    }
    
    func calculateLocally(from:String, to:String, amount:Double) {
        guard let rates = RateRealm.getRates() else {
            view?.onError(error: .fetchCurrencyFailed)
            return
        }
        guard let fromRate = rates.first(where: {$0.target == from}) else {return}
        guard let toRate = rates.first(where: {$0.target == to}) else {return}
        let result = from == "USD" ? (toRate.value * amount) : (toRate.value / fromRate.value) * amount
        let resultString = String(format: "%.5f", result)
        self.view?.didReceivedConversion(quote: "= \(resultString) \(to)")
    }
    
    func showAlert(title: String, message: String, actionHandler: @escaping () -> Void) {
        router.routeToAlert(title: title, message: message, actionHandler: actionHandler)
    }
    
    func showPicker() {
        view?.showPicker()
    }
    
    func hidePicker() {
        view?.hidePicker()
    }

}
