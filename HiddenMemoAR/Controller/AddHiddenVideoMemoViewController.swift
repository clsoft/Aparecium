//
//  AddHiddenVideoMemoViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 28/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import AVKit
import MobileCoreServices
import UIKit
import os.log


class AddHiddenVideoMemoViewController: UIViewController {
    
    // MARK: - override
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToViewController",
            let title = self.titleForRegister,
            let keyImage = self.keyImageForRegister,
            let videoURLForRegister = self.videoURLForRegister {
            if let player = playerViewController.player {
                player.pause()
            }
            
            let newHiddenMemo = HiddenMemo(
                title: title,
                keyImage: keyImage,
                content: Content.Video(videoURLForRegister)
            )
            
            HiddenMemoManager.shared.append(newHiddenMemo)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction private func selectButtonDidTap(_ sender: Any) {
        self.alertActionSheet()
    }
    
    // MARK: - internal
    
    var titleForRegister: String?
    var keyImageForRegister: UIImage?
    
    // MARK: - private
    
    private var videoURLForRegister: URL?
    
    private lazy var playerViewController: AVPlayerViewController = {
        let playerViewControllers = self.children.lazy.compactMap { $0 as? AVPlayerViewController }
        
        guard let playerViewController = playerViewControllers.first else {
            return AVPlayerViewController()
        }
        
        return playerViewController
    }()
    
}


extension AddHiddenVideoMemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? NSString,
            mediaType.isEqual(to: kUTTypeMovie as String),
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            let videoData = try? Data(contentsOf: videoURL)
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = URL(fileURLWithPath: paths[0])
            let timeStamp = String(Int(Date.timeIntervalSinceReferenceDate))
            let videoURLForRegister = documentsDirectory.appendingPathComponent(timeStamp + ".MOV")
            
            self.videoURLForRegister = videoURLForRegister
            
            do {
                try videoData?.write(to: videoURLForRegister, options: [])
            } catch {
                os_log("%s", log: .default, type: .error, error.localizedDescription)
            }
            
            self.playerViewController.player = AVPlayer(url: videoURLForRegister)
            
            if let player = self.playerViewController.player {
                player.play()
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


private extension AddHiddenVideoMemoViewController {
    
    private func alertActionSheet() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let useCameraAction = UIAlertAction(
            title: "Take a Video",
            style: .default
        ) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let usePhotoLibraryAction = UIAlertAction(
            title: "Choose from Photo Library",
            style: .default
        ) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                //I updated this version to Swift 5
                imagePicker.mediaTypes = ["public.image", "public.movie"]
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [useCameraAction, usePhotoLibraryAction, cancelAction].forEach {
            alertController.addAction($0)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
