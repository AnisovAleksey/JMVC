//
//  GameRouter.swift
//  ThemoviedbOne
//
//  Created by Aleksey Anisov on 03.12.2020.
//  Copyright © 2020 jonfir. All rights reserved.
//

import Flutter

protocol GameRouterPublic: class {
    func openGame()
}

final class GameRouter: GameRouterPublic {
    private let router: Router
    private let gameViewControllerFactory: GameViewControllerFactory
    
    init(router: Router, gameViewControllerFactory: GameViewControllerFactory) {
        self.router = router
        self.gameViewControllerFactory = gameViewControllerFactory
    }
    
    func openGame() {
        let viewController = gameViewControllerFactory.createViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        
        router.present(viewController)
    }
}
