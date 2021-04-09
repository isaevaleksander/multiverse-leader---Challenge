//
//  GroupModel.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import Foundation

class Group: NSObject {
    
    var title: String?
    var documentID: String?
    var adminUser: String?
    var users: [String]?
    var play: Bool?
    var pause: Bool?
    var stop: Bool?
    
    init(title: String?, documentID: String?, adminUser: String?, users: [String]?, play: Bool? = false, pause: Bool? = false, stop: Bool? = false) {
        self.title = title
        self.documentID = documentID
        self.adminUser = adminUser
        self.users = users
        self.play = play
        self.pause = pause
        self.stop = stop
    }
}
