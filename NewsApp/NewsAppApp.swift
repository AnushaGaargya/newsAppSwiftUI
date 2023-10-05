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

 @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

//    init() {
//        FirebaseApp.configure()
//    }
    var body: some Scene {
        WindowGroup {
            let viewModel = AppViewModel()
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
