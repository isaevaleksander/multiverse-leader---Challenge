//
//  APIClient+Downloader.swift
//  Multiverse
//
//  Created by Alex Isaev on 08.04.2021.
//

import Foundation
import FirebaseStorage

class DownloaderAPI {
    
    private init() {}
    
    static var shared: DownloaderAPI = DownloaderAPI()
    
    private var storage = Storage.storage()
    
    func downloaderAudio(completion: @escaping(Data?) -> Void) {
        
        let gsReference = storage.reference(forURL: "gs://multiverse-3c157.appspot.com/music_track_1.mp3")
        
        let megaByte = Int64(10 * 1024 * 1024)
        gsReference.getData(maxSize: megaByte) { (data, error) in
            
            if error != nil {
                completion(nil)
            } else {
                completion(data)
            }
        }
    }
}
