//
//  MainRouter.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/17/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit

/// protocol Main Wireframe
protocol MainWireframe {
    func routeToAlert(title: String, message: String, actionHandler: @escaping () -> Void)
}

/// Main Router
internal final class MainRouter {

    private unowned let viewController: UIViewController

    private init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func assembleModules() -> UIViewController {
        guard let view = R.storyboard.main().instantiateInitialViewController() as? MainViewController else {
            #if DEBUG
            fatalError("Could not load main view")
            #else
            return UIViewController()
            #endif
        }
        let router = MainRouter(viewController: view)
        let interactor = MainInteractor()
        let presenter = MainPresenter(view: view, router: router, interactor: interactor)
        view.presenter = presenter
        return view
    }

}

// MARK: - MainWireframe

extension MainRouter: MainWireframe {
    
    func routeToAlert(title: String, message: String, actionHandler: @escaping () -> Void) {
        let alert = Alert.create(title: title, message: message, okActionHandler: actionHandler)
        viewController.present(alert, animated: true, completion: nil)
    }
}
