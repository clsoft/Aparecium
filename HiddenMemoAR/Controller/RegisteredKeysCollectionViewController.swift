//
//  SavedKeyImagesCollectionViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 21/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol RegisteredKeysCollectionViewControllerDelegate: class {
    
    func didBack()
    func didDelete(_ hiddenMemo: HiddenMemo?)
    
}

class RegisteredKeysCollectionViewController: UICollectionViewController {
    
    weak var delegate: RegisteredKeysCollectionViewControllerDelegate?
    
    var keyImageForRegister: UIImage!
    var hiddenMemos: [HiddenMemo]!
    
    @IBAction func tabCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tabAddButton(_ sender: Any) {
        self.alertActionSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hiddenMemos = HiddenMemoManager.shared.hiddenMemos
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.hiddenMemos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisteredKeyCell", for: indexPath) as? RegisteredKeyCell else { return UICollectionViewCell() }
        
        let selectedHiddenMemo = self.hiddenMemos[indexPath.row]
        
        cell.registeredKeyImageView.image = selectedHiddenMemo.keyImage
        
        if selectedHiddenMemo.content?.notes != nil {
            cell.memoTypeImageView.image = UIImage(named: "NotesButton")
        } else if selectedHiddenMemo.content?.notesImage != nil {
            cell.memoTypeImageView.image = UIImage(named: "ImageButton")
        } else if selectedHiddenMemo.content?.videoURL != nil {
            cell.memoTypeImageView.image = UIImage(named: "VideoButton")
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueToRegisteredKeyDetailsViewController", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "segueToRegisteredKeyDetailsViewController" {
            if let registeredKeyDetailsViewController = segue.destination as? RegisteredKeyDetailsViewController {
                registeredKeyDetailsViewController.registeredKeysCollectionViewControllerDelegate = self
                
                if let selectedIndex = sender as? Int {
                    registeredKeyDetailsViewController.selectedHiddenMemo = self.hiddenMemos[selectedIndex]
                }
            }
        }
        
        if segue.identifier == "segueToTabBarController" {
            if let addTabBarController = segue.destination as? AddTabBarController {
                addTabBarController.registeredKeysCollectionViewControllerDelegate = self
                addTabBarController.keyImageForRegister = keyImageForRegister
            }
        }
    }
    
}


extension RegisteredKeysCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
}


extension RegisteredKeysCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.keyImageForRegister = image
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "segueToTabBarController", sender: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func alertActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let useCameraAction = UIAlertAction(title: "Take a Photo", style: .default, handler:{ _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let usePhotoLibraryAction: UIAlertAction = UIAlertAction(title: "Choose from Photo Library", style: .default) { _ in
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


extension RegisteredKeysCollectionViewController: RegisteredKeysCollectionViewControllerDelegate {
    
    func didBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didDelete(_ hiddenMemo: HiddenMemo?) {
        guard let selectedMemo = hiddenMemo else { return }
        
        HiddenMemoManager.shared.remove(by: selectedMemo.id)
        
        self.navigationController?.popViewController(animated: true)
        self.collectionView.reloadData()
    }
    
}
