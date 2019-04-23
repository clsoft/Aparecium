//
//  RegisteredKeyDetailViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 25/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import AVKit
import UIKit


class RegisteredKeyDetailViewController: UIViewController {
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel?
    @IBOutlet private weak var notesTextView: UITextView?
    @IBOutlet private weak var imageView: UIImageView?
    
    // MARK: - IBAction
    
    @IBAction private func backButtonDidTap(_ sender: Any) {
        self.registeredKeysCollectionViewControllerDelegate?.didBack()
    }
    
    @IBAction private func deleteButtonDidTap(_ sender: Any) {
        self.registeredKeysCollectionViewControllerDelegate?.didDelete(selectedHiddenMemo)
    }
    
    // MARK: - internal
    
    weak var registeredKeysCollectionViewControllerDelegate: RegisteredKeysCollectionViewControllerDelegate?
    
    var selectedHiddenMemo: HiddenMemo?
    
    // MARK: - private
    
    private lazy var playerViewController: AVPlayerViewController = {
        let playerViewControllers = self.children.lazy.compactMap { $0 as? AVPlayerViewController }
        
        guard let playerViewController = playerViewControllers.first else {
            return AVPlayerViewController()
        }
        
        return playerViewController
    }()
    
}


private extension RegisteredKeyDetailViewController {
    
    private func setUp() {
        guard let hiddenMemo = self.selectedHiddenMemo else {
            return
        }
        
        self.titleLabel?.text = hiddenMemo.title
        
        if let notes = hiddenMemo.content?.notes {
            self.notesTextView?.text = notes
            self.imageView?.image = nil
            self.playerViewController.view.isHidden = true
        } else if let notesImage = hiddenMemo.content?.notesImage {
            self.notesTextView?.text = ""
            self.imageView?.image = notesImage
            self.playerViewController.view.isHidden = true
        } else if let videoURL = hiddenMemo.content?.videoURL {
            self.notesTextView?.text = ""
            self.imageView?.image = nil
            self.playerViewController.view.isHidden = false
            self.playerViewController.player = AVPlayer(url: videoURL)
            
            if let player = playerViewController.player {
                player.play()
            }
        }
    }
    
}
