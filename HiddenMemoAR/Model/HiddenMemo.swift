//
//  HiddenMemo.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 29/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit
import ARKit


enum Content {
    
    case Notes(String)
    case NotesImage(UIImage)
    case Video(URL)
    
}


struct HiddenMemo: Codable {
    
    // MARK: - init
    
    init(title: String, keyImage: UIImage, content: Content) {
        self.id = String(Int(Date.timeIntervalSinceReferenceDate))
        self.title = title
        self.keyImage = keyImage
        self.content = content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        
        let keyImageData = try container.decode(Data.self, forKey: .keyImageData)
        self.keyImage = UIImage(data: keyImageData)
        
        if let notes = try? container.decode(String.self, forKey: .notes) {
            self.content = Content.Notes(notes)
        }
        
        if let notesImageData = try? container.decode(Data.self, forKey: .notesImageData), let notesImage = UIImage(data: notesImageData) {
            self.content = Content.NotesImage(notesImage)
        }
        
        if let videoURL = try? container.decode(URL.self, forKey: .videoURL) {
            self.content = Content.Video(videoURL)
        }
    }
    
    // MARK: - internal
    
    let id: String
    let title: String
    let keyImage: UIImage?
    
    var content: Content?
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        
        if let keyImageData = self.keyImage?.pngData() {
            try container.encode(keyImageData, forKey: .keyImageData)
        }
        
        try container.encode(self.content?.notes, forKey: .notes)
        
        if let noteImageData = self.content?.notesImage?.pngData() {
            try container.encode(noteImageData, forKey: .notesImageData)
        }
        
        try container.encode(self.content?.videoURL, forKey: .videoURL)
    }
    
    func arReferenceImage() -> ARReferenceImage? {
        guard let cgKeyImage = self.keyImage?.cgImage else { return nil }
        
        let referenceImage = ARReferenceImage(cgKeyImage, orientation: .down, physicalWidth: CGFloat(1.0))
        referenceImage.name = self.id
            
        return referenceImage
    }
    
    // MARK: - private
    
    private enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case title = "title"
        case keyImageData = "keyImageData"
        case notes = "notes"
        case notesImageData = "notesImageData"
        case videoURL = "videoURL"
        
    }
    
}


extension Content {
    
    var notes: String? {
        switch self {
        case .Notes(let notes):
            return notes
        default:
            return nil
        }
    }
    
    var notesImage: UIImage? {
        switch self {
        case .NotesImage(let notesImage):
            return notesImage
        default:
            return nil
        }
    }
    
    var videoURL: URL? {
        switch self {
        case .Video(let videoURL):
            return videoURL
        default:
            return nil
        }
    }
    
}
