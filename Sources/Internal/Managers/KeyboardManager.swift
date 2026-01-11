//
//  KeyboardManager.swift of NavigationView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI
import Combine

class KeyboardManager: ObservableObject {
    @Published private(set) var height: CGFloat = .zero
    private var subscription: [AnyCancellable] = []

    static let shared: KeyboardManager = .init()
    private init() { subscribeToKeyboardEvents() }
}

// MARK: - Hiding Keyboard
extension KeyboardManager {
    static func hideKeyboard() { UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) }
}

// MARK: - Show / Hide Events
private extension KeyboardManager {
    func subscribeToKeyboardEvents() {
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { rect -> CGFloat in
                // If keyboard is off-screen (y >= screen height), height is zero
                let screenHeight = UIScreen.main.bounds.height
                return rect.origin.y >= screenHeight ? .zero : rect.height
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.height = $0 }
            .store(in: &subscription)
    }
}
