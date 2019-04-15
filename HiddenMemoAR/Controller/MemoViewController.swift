//
//  MemoViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 19/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit
import ARKit
import AVKit
import CoreGraphics


class MemoViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var notesTextView: UITextView!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - IBAction
    
    @IBAction private func tabCloseButton(_ sender: Any) {
        if let player = self.playerViewController.player {
            player.pause()
        }
        
        self.setIsHidden(true, animated: true)
    }
    
    // MARK: - internal
    
    func show(_ hiddenMemo: HiddenMemo, isAutoHide: Bool = false) {
        self.hideTimer?.invalidate()
        
        self.titleLabel.text = hiddenMemo.title
        
        if let notes = hiddenMemo.content?.notes {
            self.notesTextView.text = notes
            self.imageView.image = nil
            self.playerViewController.view.isHidden = true
        } else if let notesImage = hiddenMemo.content?.notesImage {
            self.notesTextView.text = ""
            self.imageView.image = notesImage.alphaImage(0.9)
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
        
        self.setIsHidden(false, animated: true)
        
        if isAutoHide {
            self.hideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false) { [weak self] _ in
                self?.setIsHidden(true, animated: true)
            }
        }
    }
    
    // MARK: - private
    
    private let displayDuration: TimeInterval = 60.0
    private var hideTimer: Timer?
    
    private lazy var playerViewController: AVPlayerViewController = {
        return children.lazy.compactMap { $0 as? AVPlayerViewController }.first!
    }()
    
    private func setIsHidden(_ isHidden: Bool, animated: Bool) {
        view.isHidden = false
        
        guard animated else {
            self.view.alpha = isHidden ? 0 : 1
            self.titleLabel.alpha = isHidden ? 0 : 1
            self.notesTextView.alpha = isHidden ? 0 : 1
            self.imageView.alpha = isHidden ? 0 : 1
            self.playerViewController.view.alpha = isHidden ? 0 : 1
            
            return
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
            self.view.alpha = isHidden ? 0 : 1
            self.titleLabel.alpha = isHidden ? 0 : 1
            self.notesTextView.alpha = isHidden ? 0 : 1
            self.imageView.alpha = isHidden ? 0 : 1
            self.playerViewController.view.alpha = isHidden ? 0 : 1
        }, completion: nil)
    }
    
}
