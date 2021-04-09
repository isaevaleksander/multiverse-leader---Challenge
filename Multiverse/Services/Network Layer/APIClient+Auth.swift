//
//  APIClient+Auth.swift
//  Multiverse
//
//  Created by Alex Isaev on 07.04.2021.
//

import Foundation
import Firebase

class AuthAPI {
    
    private init() {}
    
    static var shared: AuthAPI = AuthAPI()
    
    private var auth = Auth.auth()
    
    func createUser(email: String, password: String, completion: @escaping(String?) -> Void) {
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
          
            if error != nil {
                completion(error?.localizedDescription)
            } else {
                completion(nil)
            }
        }
    }
}
