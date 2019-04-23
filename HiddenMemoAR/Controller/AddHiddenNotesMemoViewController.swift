//
//  AddHiddenNotesMemoViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 24/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit


class AddHiddenNotesMemoViewController: UIViewController {
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(self.dismissKeyboard)
        )
        
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToViewController",
            let notes = self.textView?.text,
            let title = self.titleForRegister,
            let keyImage = self.keyImageForRegister {
            let newHiddenMemo = HiddenMemo(
                title: title,
                keyImage: keyImage,
                content: Content.Notes(notes)
            )
            
            HiddenMemoManager.shared.append(newHiddenMemo)
        }
    
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var textView: UITextView?
    
    // MARK: - internal
    
    var titleForRegister: String?
    var keyImageForRegister: UIImage?
    
}


private extension AddHiddenNotesMemoViewController {
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}
