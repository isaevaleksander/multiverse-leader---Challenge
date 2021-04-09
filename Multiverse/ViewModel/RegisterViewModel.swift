//
//  RegisterViewModel.swift
//  Multiverse
//
//  Created by Alex Isaev on 07.04.2021.
//

import Foundation
import Firebase

class RegisterViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showingAlert: Bool = false
    
    @Published var isLoggedin: Bool = false
    
    var errorMessage: String = ""
    
    func registerUser() {
        
        AuthAPI.shared.createUser(email: email, password: password) { (message) in
            if let errorMessage = message {
                self.errorMessage = errorMessage
                self.showingAlert = true
                
            } else {
                UserDefaults.standard.set(true, forKey: kIsLoggedin)
                self.isLoggedin = true
            }
        }
    }
}
