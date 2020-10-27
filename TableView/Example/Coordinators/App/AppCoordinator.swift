//
//  AppCoordinator.swift
//  TableView
//
//  Created by Vadym Zhydenko on 27.10.2020.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    private let viewControllersFactory: AppViewControllersFactory
    private let coordinatorsFactory: CoordinatorsFactory
    
    init(window: UIWindow, viewControllersFactory: AppViewControllersFactory, coordinatorsFactory: CoordinatorsFactory) {
        self.window = window
        self.navigationController = viewControllersFactory.navigationController()
        self.viewControllersFactory = viewControllersFactory
        self.coordinatorsFactory = coordinatorsFactory
    }
    
    // MARK: - Coordinator
    var parent: Coordinator?
    var child: Coordinator?
    
    func start() {
        let viewController = viewControllersFactory.examples(
            singleSelectionTableViewData: { [weak self] in self?.pushSingleSelection() },
            multipleSectionsTableViewData: { [weak self] in self?.pushMultipleSection() },
            loadModeTableViewData: { [weak self] in self?.pushUpdatableSingleSection() },
            navigateDismiss: { viewController in
                fatalError("\(viewController) can't be dismissed")
            }
        )
        navigationController.setViewControllers([viewController], animated: false)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

private extension AppCoordinator {
    
    func pushSingleSelection() {
        let coordinator = coordinatorsFactory.examplePush(navigationController: navigationController, presenter: TableViewPresenterExample1.self)
        present(coordinator: coordinator)
    }
    
    func pushMultipleSection() {
        let coordinator = coordinatorsFactory.examplePush(navigationController: navigationController, presenter: TableViewPresenterExample2.self)
        present(coordinator: coordinator)
    }
    
    func pushUpdatableSingleSection() {
        let coordinator = coordinatorsFactory.examplePresent(navigationController: navigationController, presenter: TableViewPresenterExample3.self)
        present(coordinator: coordinator)
    }
    
}
