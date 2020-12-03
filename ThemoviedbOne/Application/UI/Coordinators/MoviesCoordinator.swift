import UIKit

final class MoviesCoordinator: BaseCoordinator {
    
    var finishFlow: VoidClosure?
    
    private let screenFactory: ScreenFactory
    private let router: Router
    private let gameRouter: GameRouterPublic
    
    init(router: Router, screenFactory: ScreenFactory, gameRouter: GameRouterPublic) {
        self.screenFactory = screenFactory
        self.router = router
        self.gameRouter = gameRouter
    }
    
    override func start() {
        showMovies()
    }
    
    private func showMovies() {
        let moviesScreen = screenFactory.makeMoviesScreen()
        moviesScreen.onSelectMovie = { [weak self] in self?.showMovie(id: $0) }
        moviesScreen.onShowFavoriteAlert = { [weak router] data in
            let alert = UIAlertController(inputData: data)
            router?.present(alert)
        }
        moviesScreen.onShowGame = { [weak gameRouter] in
            gameRouter?.openGame()
        }
        router.setRootModule(moviesScreen, hideBar: false)
    }
    
    private func showMovie(id: Movie.Id) {
        let moviesScreen = screenFactory.makeMovieScreen(id: id)
        router.push(moviesScreen)
    }
    
}
