//
//  Public+NavigationManager.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import Foundation

public protocol ExternalNavigationRouter: AnyObject, Sendable {
    @MainActor func handlePush(_ view: any NavigatableView, animation: TransitionAnimation)
    @MainActor func handlePop()
    @MainActor func handlePopToRoot()
}

public extension NavigationManager {
    /// Returns to a previous view on the stack
    static func pop() { performOperation(.removeLast) }

    /// Returns to view with provided type
    static func pop<N: NavigatableView>(to view: N.Type) { performOperation(.removeAll(toID: .init(describing: view))) }

    /// Returns to a root view
    static func popToRoot() { performOperation(.removeAllExceptFirst) }

    /// Pushes a view onto the navigation stack
    static func push(_ view: some NavigatableView, animation: TransitionAnimation) { performOperation(.insert(view, animation)) }
}
