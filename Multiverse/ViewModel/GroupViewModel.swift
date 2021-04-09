//
//  GroupViewModel.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import Foundation
import FirebaseAuth

class GroupViewModel: ObservableObject {
    
    @Published var groups: [Group] = []
    @Published var isCreatedGroup: Bool = false
    @Published var showAlert: Bool = false
    
    var errorMessage: String = ""

    private var title: String = ""
    
    func getAllGroups() {
        
        GroupAPI.shared.getAllGroups { [weak self] (groups) in
            self?.groups = groups
        }
    }
    
    func createGroup(title: String) {
        
        if let _ = groups.first(where: { $0.title == title }) {
            errorMessage = "This name is already taken. Enter another"
            showAlert = true
            return
        }
        
        
        
        GroupAPI.shared.createGroup(title: title, completion: { [weak self] isSuccess in
            if isSuccess {
                self?.title = title
                self?.isCreatedGroup = true
            }
        })
    }
    
    func createdGroup(completion: @escaping(Group?) -> Void) {
        
        let user = Auth.auth().currentUser
        let group = groups.reversed().first(where: { $0.title == title && $0.adminUser == user?.uid })
        
        completion(group)
    }
}
