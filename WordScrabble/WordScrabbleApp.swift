//
//  WordScrabbleApp.swift
//  WordScrabble
//
//  Created by Garrett Keyes on 11/15/25.
//

import SwiftUI

@main
struct WordScrabbleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemOrange // orange background
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // inline title color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black] // large title color

        let navBar = UINavigationBar.appearance()
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = appearance
        navBar.compactAppearance = appearance
        navBar.tintColor = .black // bar button items (e.g., “New Game”)
    }
}
