//
//  FlashlightButton.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 28/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit
import AVFoundation


class FlashlightButton: UIButton {
    
    // MARK: - init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - override
    
    override var isHidden: Bool {
        didSet {
            guard let captureDevice = AVCaptureDevice.default(for: .video), captureDevice.hasTorch else {
                if !self.isHidden {
                    self.isHidden = true
                }
                
                return
            }
            
            if self.isHidden {
                self.isToggled = false
            }
        }
    }
    
    // MARK: - internal
    
    var isToggled: Bool = false {
        didSet {
            let imageName = self.isToggled ? "FlashlightOnButton" : "FlashlightOffButton"
            
            setImage(UIImage(named: imageName), for: .normal)
            
            guard let captureDevice = AVCaptureDevice.default(for: .video), captureDevice.hasTorch else {
                if self.isToggled {
                    self.isToggled = false
                }
                
                return
            }
            
            do {
                try captureDevice.lockForConfiguration()
                
                let mode: AVCaptureDevice.TorchMode = self.isToggled ? .on : .off
                
                if captureDevice.isTorchModeSupported(mode) {
                    captureDevice.torchMode = mode
                }
                
                captureDevice.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
    }
    
}
