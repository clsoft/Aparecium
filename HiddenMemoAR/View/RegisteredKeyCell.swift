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
        self.imageView?.image = nil
        self.contentTypeImageView?.image = nil
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private weak var imageView: UIImageView?
    @IBOutlet private weak var contentTypeImageView: UIImageView?
    
    // MARK: - internal
    
    func setImage(_ image: UIImage?) {
        self.imageView?.image = image
    }
    
    func setContentTypeImage(_ image: UIImage?) {
        self.contentTypeImageView?.image = image
    }
    
}
