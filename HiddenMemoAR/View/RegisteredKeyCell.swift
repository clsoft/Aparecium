//
//  RegisteredKeyCell.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 29/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit


class RegisteredKeyCell: UICollectionViewCell {
    
    // MARK: - init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - override
    
    override func prepareForReuse() {
        self.registeredKeyImageView.image = nil
        self.memoTypeImageView.image = nil
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var registeredKeyImageView: UIImageView!
    @IBOutlet weak var memoTypeImageView: UIImageView!
    
}
