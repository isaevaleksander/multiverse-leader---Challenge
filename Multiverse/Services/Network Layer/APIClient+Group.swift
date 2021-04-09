//
//  APIClient+Group.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class GroupAPI {
    
    private init() {}
    
    static var shared: GroupAPI = GroupAPI()
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func getAllGroups(completion: @escaping([Group]) -> Void) {
        
        db.collection("groups").addSnapshotListener { snapshot, error in
            
            guard let doc = snapshot?.documents else { return }
            
            let groups = doc.map({ docSnapshot -> Group in
                let data = docSnapshot.data()
                let documentID = docSnapshot.documentID
                let title = data["title"] as? String
                let adminUser = data["adminUser"] as? String
                let users = data["users"] as? [String]
                return Group(title: title, documentID: documentID, adminUser: adminUser, users: users)
            })
            
            completion(groups)
        }
    }
    
    func createGroup(title: String, completion: @escaping(Bool) -> Void) {
        
        if let user = user {
            let docData: [String: Any] = [
                "title": title,
                "adminUser": user.uid,
                "users": [user.uid],
                "play": false,
                "stop": false,
                "pause": false]
            
            db.collection("groups").document(title).setData(docData) { err in
                if err != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    func setUserToGroup(_ documentID: String?, removeUser: Bool = false) {
        
        if let user = user {
            getCurrentGroup(documentID ?? "") { group in
                
                if let group = group, var adminUser = group.adminUser, var users = group.users {
                    
                    if removeUser {
                        if let index = group.users?.firstIndex(where: { $0 == user.uid }) {
                            users.remove(at: index)
                            
                            if user.uid == group.adminUser {
                                let newAdminUser = users.randomElement()
                                adminUser = newAdminUser ?? ""
                            }
                            
                            if users.isEmpty {
                                self.db.collection("groups").document(group.title ?? "").delete()
                            }
                        }
                    } else {
                        if (users.first(where: { $0 == user.uid })) != nil {
                            return
                        }
                        users.append(user.uid)
                    }
                    
                    let docData: [String: Any] = [
                        "title": documentID ?? "",
                        "adminUser": adminUser,
                        "users": users,
                        "play": false,
                        "stop": false,
                        "pause": false]
                    
                    self.db.collection("groups").document(group.documentID ?? "").updateData(docData)
                }
            }
        }
    }
    
    func changesGroup(_ documentID: String, completion: @escaping(Group?) -> Void) {
        
        db.collection("groups").document(documentID).addSnapshotListener { documentSnapshot, error in
            
            if error != nil {
                completion(nil)
            } else {
                let group = documentSnapshot.map({ docSnapshot -> Group in
                    let data = docSnapshot.data()
                    let documentID = docSnapshot.documentID
                    let title = data?["title"] as? String
                    let adminUser = data?["adminUser"] as? String
                    let users = data?["users"] as? [String]
                    let play = data?["play"] as? Bool
                    let pause = data?["pause"] as? Bool
                    let stop = data?["stop"] as? Bool
                    return Group(title: title, documentID: documentID, adminUser: adminUser, users: users, play: play, pause: pause, stop: stop)
                })
                completion(group)
            }
        }
    }
    
    func updateGroup(_ group: Group) {
        let docData: [String: Any] = [
            "title": group.documentID ?? "",
            "adminUser": group.adminUser ?? "",
            "users": group.users ?? [],
            "play": group.play ?? false,
            "stop": group.stop ?? false,
            "pause": group.pause ?? false]
        
        self.db.collection("groups").document(group.documentID ?? "").updateData(docData)
    }
    
    private func getCurrentGroup(_ documentID: String, completion: @escaping(Group?) -> Void) {
        
        db.collection("groups").document(documentID).getDocument { (document, error) in
            
            if error != nil {
                completion(nil)
            } else {
                let group = document.map({ docSnapshot -> Group in
                    let data = docSnapshot.data()
                    let documentID = docSnapshot.documentID
                    let title = data?["title"] as? String
                    let adminUser = data?["adminUser"] as? String
                    let users = data?["users"] as? [String]
                    return Group(title: title, documentID: documentID, adminUser: adminUser, users: users)
                })
                completion(group)
            }
        }
    }
}
