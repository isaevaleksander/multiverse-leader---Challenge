//
//  ViewRouter.swift
//  Multiverse
//
//  Created by Alex Isaev on 09.04.2021.
//

import Foundation
import FirebaseAuth

enum Page {
    case registerView
    case groupView
}

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .registerView
    
    init() {
        if UserDefaults.standard.bool(forKey: kIsLoggedin) && Auth.auth().currentUser != nil {
            currentPage = .groupView
        }
    }
}
