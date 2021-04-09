//
//  MultiverseApp.swift
//  Multiverse
//
//  Created by Alex Isaev on 07.04.2021.
//

import SwiftUI

@main
struct MultiverseApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            StartView(viewRouter: viewRouter)
        }
    }
}
