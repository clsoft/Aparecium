//
//  UIImage+Extension.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 16/04/2019.
//  Copyright © 2019 HyungJung Kim. All rights reserved.
//
import UIKit


extension UIImage {
    
    func alphaImage(_ alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}
