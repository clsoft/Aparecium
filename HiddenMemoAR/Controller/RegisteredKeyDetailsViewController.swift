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
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var notesTextView: UITextView!
    @IBOutlet weak private var imageView: UIImageView!
    
    // MARK: - IBAction
    
    @IBAction private func tabBackButton(_ sender: Any) {
        self.registeredKeysCollectionViewControllerDelegate?.didBack()
    }
    
    @IBAction private func tabDeleteButton(_ sender: Any) {
        self.registeredKeysCollectionViewControllerDelegate?.didDelete(selectedHiddenMemo)
    }
    
    // MARK: - internal
    
    weak var registeredKeysCollectionViewControllerDelegate: RegisteredKeysCollectionViewControllerDelegate?
    
    var selectedHiddenMemo: HiddenMemo?
    
    // MARK: - private
    
    private lazy var playerViewController: AVPlayerViewController = {
        let playerViewControllerChildren = children.lazy.compactMap { $0 as? AVPlayerViewController }
        
        guard let playerViewController = playerViewControllerChildren.first else {
            return AVPlayerViewController()
        }
        
        return playerViewController
    }()
    
    private func setup() {
        guard let hiddenMemo = self.selectedHiddenMemo else {
            return
        }
        
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
