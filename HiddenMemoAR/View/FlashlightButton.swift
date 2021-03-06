//
//  FlashlightButton.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 28/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import AVFoundation
import UIKit
import os.log


class FlashlightButton: UIButton {
    
    // MARK: - init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - override
    
    override var isHidden: Bool {
        didSet {
            guard let captureDevice = AVCaptureDevice.default(for: .video),
                captureDevice.hasTorch
            else {
                if self.isHidden == false {
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
            
            self.setImage(UIImage(named: imageName), for: .normal)
            
            guard let captureDevice = AVCaptureDevice.default(for: .video),
                captureDevice.hasTorch
            else {
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
                os_log("%s", log: .default, type: .error, error.localizedDescription)
            }
        }
    }
    
}
