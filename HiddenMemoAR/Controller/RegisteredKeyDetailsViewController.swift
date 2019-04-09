//
//  RegisteredKeyDetailsViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 25/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit
import AVKit

class RegisteredKeyDetailsViewController: UIViewController {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var notesTextView: UITextView!
    @IBOutlet weak private var imageView: UIImageView!
    
    weak var registeredKeysCollectionViewControllerDelegate: RegisteredKeysCollectionViewControllerDelegate?
    
    var selectedHiddenMemo: HiddenMemo?
    
    lazy private var playerViewController: AVPlayerViewController = {
        return self.children.lazy.compactMap { $0 as? AVPlayerViewController }.first!
    }()
    
    @IBAction private func tabBackButton(_ sender: Any) {
        self.registeredKeysCollectionViewControllerDelegate?.didBack()
    }
    
    @IBAction private func tabDeleteButton(_ sender: Any) {
        self.registeredKeysCollectionViewControllerDelegate?.didDelete(selectedHiddenMemo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    private func setup() {
        guard let hiddenMemo = self.selectedHiddenMemo else { return }
        
        self.titleLabel.text = hiddenMemo.title
        
        if let notes = hiddenMemo.content?.notes {
            self.notesTextView.text = notes
            self.imageView.image = nil
            self.playerViewController.view.isHidden = true
        } else if let notesImage = hiddenMemo.content?.notesImage {
            self.notesTextView.text = ""
            self.imageView.image = notesImage
            self.playerViewController.view.isHidden = true
        } else if let videoURL = hiddenMemo.content?.videoURL {
            self.notesTextView.text = ""
            self.imageView.image = nil
            self.playerViewController.view.isHidden = false
            self.playerViewController.player = AVPlayer(url: videoURL)
            
            if let player = playerViewController.player {
                player.play()
            }
        }
    }
    
}
