//
//  SavedKeyImagesCollectionViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 21/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import MobileCoreServices
import UIKit


protocol RegisteredKeysCollectionViewControllerDelegate: class {
    
    func didBack()
    func didDelete(_ hiddenMemo: HiddenMemo?)
    
}


class RegisteredKeysCollectionViewController: UICollectionViewController {
    
    // MARK: - override
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return HiddenMemoManager.shared.hiddenMemos.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RegisteredKeyCell",
            for: indexPath
        ) as? RegisteredKeyCell
        else {
            return UICollectionViewCell()
        }
        
        let selectedHiddenMemo = HiddenMemoManager.shared.hiddenMemos[indexPath.row]
        
        cell.setImage(selectedHiddenMemo.keyImage)
        
        if selectedHiddenMemo.content?.notes != nil {
           cell.setContentTypeImage(UIImage(named: "NotesButton"))
        } else if selectedHiddenMemo.content?.notesImage != nil {
            cell.setContentTypeImage(UIImage(named: "ImageButton"))
        } else if selectedHiddenMemo.content?.videoURL != nil {
            cell.setContentTypeImage(UIImage(named: "VideoButton"))
        }
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        self.performSegue(
            withIdentifier: "segueToRegisteredKeyDetailViewController",
            sender: indexPath.row
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToRegisteredKeyDetailViewController",
            let registeredKeyDetailViewController = segue.destination as? RegisteredKeyDetailViewController,
            let selectedIndex = sender as? Int {
            registeredKeyDetailViewController.registeredKeysCollectionViewControllerDelegate = self
            registeredKeyDetailViewController.selectedHiddenMemo = HiddenMemoManager.shared.hiddenMemos[selectedIndex]
        }
        
        if segue.identifier == "segueToTabBarController",
            let addTabBarController = segue.destination as? AddTabBarController {
            addTabBarController.registeredKeysCollectionViewControllerDelegate = self
            addTabBarController.keyImageForRegister = keyImageForRegister
        }
    }
    
    // MARK: - internal
    
    weak var delegate: RegisteredKeysCollectionViewControllerDelegate?
    
    var keyImageForRegister: UIImage?
    
    // MARK: - IBAction
    
    @IBAction private func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func addButtonDidTap(_ sender: Any) {
        self.alertActionSheet()
    }
    
}


extension RegisteredKeysCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }
    
}


extension RegisteredKeysCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? NSString,
            mediaType.isEqual(to: kUTTypeImage as String),
            let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            let image = editedImage == nil ? originalImage : editedImage
            
            self.keyImageForRegister = image
        }
        
        self.dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "segueToTabBarController", sender: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func alertActionSheet() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let useCameraAction = UIAlertAction(
            title: "Take a Photo",
            style: .default
        ) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
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
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                
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


extension RegisteredKeysCollectionViewController: RegisteredKeysCollectionViewControllerDelegate {
    
    func didBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didDelete(_ hiddenMemo: HiddenMemo?) {
        guard let selectedHiddenMemo = hiddenMemo else {
            return
        }
        
        HiddenMemoManager.shared.remove(by: selectedHiddenMemo.id)
        
        self.navigationController?.popViewController(animated: true)
        self.collectionView.reloadData()
    }
    
}
