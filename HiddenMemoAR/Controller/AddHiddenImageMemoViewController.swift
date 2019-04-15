//
//  AddHiddenImageMemoViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 24/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit
import MobileCoreServices


class AddHiddenImageMemoViewController: UIViewController {
    
    // MARK: - override
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "segueToViewController" {
            if let notesImage = imageView.image {
                let newHiddenMemo = HiddenMemo(title: self.titleForRegister, keyImage: self.keyImageForRegister, content: Content.NotesImage(notesImage))
                
                HiddenMemoManager.shared.append(newHiddenMemo)
            }
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - IBAction
    
    @IBAction private func tabImageSelectButton(_ sender: Any) {
        self.alertActionSheet()
    }
    
    // MARK: - internal
    
    var titleForRegister: String!
    var keyImageForRegister: UIImage!
    
}


extension AddHiddenImageMemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.imageView.image = image
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func alertActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let useCameraAction = UIAlertAction(title: "Take a Photo", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let usePhotoLibraryAction = UIAlertAction(title: "Choose from Photo Library", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(useCameraAction)
        alertController.addAction(usePhotoLibraryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
