//
//  MainInteractor.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/17/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Foundation
import RealmSwift

/// protocol Main UseCase
protocol MainUseCase {
    func requestRecentQuotes(completionHandler: @escaping CurConvResultHandler)
    func requestQuote(from:String, to:String, amount:Double, completionHandler: @escaping CurConvResultHandler)
    func getRateObjects() -> Results<RateRealm>
    func getInfoObject() -> InfoRealm?
    func clearRealm()
}

/// Main Interactor
internal final class MainInteractor {
    
    private let apiClient: ApiClientProtocol

    init(apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
    }
}

// MARK: - MainUseCase

extension MainInteractor: MainUseCase {
    
    func requestRecentQuotes(completionHandler: @escaping CurConvResultHandler) {
        apiClient.request(LiveRequest(), completion: { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
    
    func requestQuote(from: String, to: String, amount: Double, completionHandler: @escaping CurConvResultHandler) {
        apiClient.request(ConvertRequest(from: from, to: to, amount: amount)) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getRateObjects() -> Results<RateRealm> {
        let realm = try! Realm()
        return realm.objects(RateRealm.self)
    }
    
    func getInfoObject() -> InfoRealm? {
        let realm = try! Realm()
        return realm.objects(InfoRealm.self).first
    }
    
    func clearRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}
