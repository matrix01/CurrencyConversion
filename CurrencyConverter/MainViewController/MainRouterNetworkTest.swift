//
//  MainRouterNetworkTest.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/19/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import XCTest
@testable import CurrencyConverter

class MainRouterNetworkTest: XCTestCase {

    let interactor = MainInteractor.init(apiClient: ApiClientStab())

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
    
    func testLiveFetch() {
        interactor.requestRecentQuotes { result in
            switch result {
            case.success(let data):
                do {
                    _ = try JSONDecoder().decode(CurrencyRealm.self, from: data)
                } catch {
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription.message)
            }
        }
    }
    
    func testRealmFetch() {
        interactor.requestRecentQuotes { result in
            switch result {
            case.success(let data):
                do {
                    _ = try JSONDecoder().decode(CurrencyRealm.self, from: data)
                    let realmData = self.interactor.requestSavedQuotes()
                    if realmData == nil {
                        XCTFail("Realm data save failed")
                    }
                } catch {
                    XCTFail(error.localizedDescription)
                }
            case .failure(let error):
                XCTFail(error.localizedDescription.message)
            }
        }
    }

}
