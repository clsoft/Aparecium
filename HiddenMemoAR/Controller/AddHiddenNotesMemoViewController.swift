//
//  AddHiddenNotesMemoViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 24/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit

class AddHiddenNotesMemoViewController: UIViewController {
    
    @IBOutlet weak private var notesTextView: UITextView!
    
    var titleForRegister: String!
    var keyImageForRegister: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureForView = UITapGestureRecognizer(target: self, action: #selector(tapToDismissKeyboard))
        
        view.addGestureRecognizer(tapGestureForView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "segueToViewController" {
            if let notes = notesTextView.text {
                let newHiddenMemo = HiddenMemo(title: self.titleForRegister, keyImage: self.keyImageForRegister, content: Content.Notes(notes))
                
                HiddenMemoManager.shared.append(newHiddenMemo)
            }
        }
    }
    
    @objc private func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
