//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Anusha S on 04/10/23.
//

import SwiftUI
import Firebase

@main
struct NewsAppApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
