//
//  SaveFileManager.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import Foundation

class LocalFileManager: NSObject {
    
    static var shared: LocalFileManager = LocalFileManager()
    
    private override init() {}
    
    func saveAudio(_ data: Data) {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = "audio"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadAudio() -> Data? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let url = URL(fileURLWithPath: dirPath).appendingPathComponent("audio")
            let audio = try? Data(contentsOf: url)
            return audio
        }
        return nil
    }
}
