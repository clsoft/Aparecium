//
//  RegisteredKeyCell.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 29/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit

class RegisteredKeyCell: UICollectionViewCell {
    
    @IBOutlet weak var registeredKeyImageView: UIImageView!
    @IBOutlet weak var memoTypeImageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        self.registeredKeyImageView.image = nil
        self.memoTypeImageView.image = nil
    }
    
}
