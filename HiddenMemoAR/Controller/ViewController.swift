//
//  ViewController.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 19/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ViewController: UIViewController {
    
    // MARK: - override
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.delegate = self
        self.sceneView.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.resetTracking()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self.sceneView)
        let hitTestResults = self.sceneView.hitTest(location, options: nil)
        
        if let hitTestResult = hitTestResults.first?.node {
            DispatchQueue.main.async {
                guard let id = hitTestResult.name, let hiddenMemo = HiddenMemoManager.shared.hiddenMemo(by: id) else {
                    return
                }
                
                self.memoViewController.show(hiddenMemo)
            }
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private var sceneView: ARSCNView!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var flashlightButton: FlashlightButton!
    @IBOutlet private weak var registeredKeysButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction private func tabFlashlightButton(_ sender: Any) {
        guard !self.flashlightButton.isHidden && self.flashlightButton.isEnabled else {
            return
        }
        
        self.flashlightButton.isToggled = !self.flashlightButton.isToggled
    }
    
    // MARK: - private
    
    private let serialQueueForSceneKit = DispatchQueue(label: "kr.co.clsoft.HiddenMemoAR.serialQueueForSceneKit")
    
    private var session: ARSession {
        return self.sceneView.session
    }
    
    private var isRestartAvailable = true
    
    private lazy var memoViewController: MemoViewController = {
        let memoViewControllerChildren = children.lazy.compactMap { $0 as? MemoViewController }
        
        guard let memoViewController = memoViewControllerChildren.first else {
            return MemoViewController()
        }
        
        return memoViewController
    }()
    
    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        let arReferenceImages = HiddenMemoManager.shared.hiddenMemos.compactMap { $0.arReferenceImage() }
        
        configuration.detectionImages = Set(arReferenceImages)
        
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
}


extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        
        let referenceImage = imageAnchor.referenceImage
        
        self.serialQueueForSceneKit.async {
            let plane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: "Circle.png")
            
            plane.firstMaterial = material
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.name = referenceImage.name ?? ""
            planeNode.scale = SCNVector3(1, 1, 1)
            planeNode.eulerAngles.x = -.pi / 2
            planeNode.runAction(.fadeOut(duration: 1))
            planeNode.runAction(.scale(to: 2, duration: 1))
            
            node.addChildNode(planeNode)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        node.childNodes.first?.removeAllActions()
        node.childNodes.first?.opacity = 1
        node.childNodes.first?.scale = SCNVector3(1, 1, 1)
        node.childNodes.first?.runAction(.fadeOut(duration: 1))
        node.childNodes.first?.runAction(.scale(to: 2, duration: 2))
    }
    
}


extension ViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else {
            return
        }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        let errorMessage = messages.compactMap { $0 }.joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.alertErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        self.blurView.isHidden = false
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        self.blurView.isHidden = true
        
        self.restartExperience()
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    private func alertErrorMessage(title: String, message: String) {
        self.blurView.isHidden = false
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            
            self.blurView.isHidden = true
            
            self.resetTracking()
        }
        
        alertController.addAction(restartAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func restartExperience() {
        guard self.isRestartAvailable else {
            return
        }
        
        self.isRestartAvailable = false
        
        self.resetTracking()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.isRestartAvailable = true
        }
    }
    
}
