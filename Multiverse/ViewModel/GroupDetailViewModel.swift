//
//  GroupDetailViewModel.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import Foundation
import AVKit
import FirebaseAuth

class GroupDetailViewModel: ObservableObject {
    
    @Published var audioPlayer: AVAudioPlayer!
    @Published var currentGroup: Group?
    
    @Published var showLoadingIndicator: Bool = true
    
    private let user = Auth.auth().currentUser
    
    func setPlayer() {
        
        if let audio = LocalFileManager.shared.loadAudio() {
            self.showLoadingIndicator = false
            self.audioPlayer = try! AVAudioPlayer(data: audio)
        } else {
            DownloaderAPI.shared.downloaderAudio { [weak self] (audio) in
                self?.showLoadingIndicator = false
                if let audio = audio {
                    LocalFileManager.shared.saveAudio(audio)
                    self?.audioPlayer = try! AVAudioPlayer(data: audio)
                }
            }
        }
    }
    
    func playMusic() {
        if LocalFileManager.shared.loadAudio() == nil {
            return
        }
        
        audioPlayer.play()
        
        if user?.uid != currentGroup?.adminUser {
            return
        }
        currentGroup?.play = true
        currentGroup?.pause = false
        currentGroup?.stop = false
        updateGroup()
    }
    
    func pauseMusic() {
        if LocalFileManager.shared.loadAudio() == nil {
            return
        }
        
        audioPlayer.pause()
        
        if user?.uid != currentGroup?.adminUser {
            return
        }
        currentGroup?.play = false
        currentGroup?.pause = true
        currentGroup?.stop = false
        updateGroup()
    }
    
    func stopMusic() {
        if LocalFileManager.shared.loadAudio() == nil {
            return
        }
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        
        if user?.uid != currentGroup?.adminUser {
            return
        }
        currentGroup?.play = false
        currentGroup?.pause = false
        currentGroup?.stop = true
        updateGroup()
    }
    
    func changesGroup(_ documentID: String) {
        
        GroupAPI.shared.changesGroup(documentID, completion: { [weak self] group in
            if let group = group {
                
                if self?.user?.uid != group.adminUser {
                    
                    if group.play == true {
                        self?.playMusic()
                    } else if group.pause == true {
                        self?.pauseMusic()
                    } else if group.stop == true {
                        self?.stopMusic()
                    }
                }
                
                self?.currentGroup = group
            }
        })
    }
    
    func addedUserForGroup(group: Group?) {
        
        currentGroup = group
        changesGroup(group?.documentID ?? "")
        GroupAPI.shared.setUserToGroup(group?.documentID)
    }
    
    func removeUserForGroup(documentID: String?) {
        
        GroupAPI.shared.setUserToGroup(documentID, removeUser: true)
    }
    
    func chechUserAdmin() -> Bool {
        
        if let group = currentGroup, group.adminUser == user?.uid {
            return true
        } else {
            return false
        }
    }
    
    private func updateGroup() {
        
        if let group = currentGroup {
            GroupAPI.shared.updateGroup(group)
        }
    }
}

