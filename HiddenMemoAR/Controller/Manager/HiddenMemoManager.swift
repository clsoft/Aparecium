//
//  HiddenMemoManager.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 23/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import ARKit
import UIKit


final class HiddenMemoManager {
    
    // MARK: - Singleton pattern
    
    static let shared = HiddenMemoManager()
    
    private init() {
        self.hiddenMemos = UserDefaultsManager.shared.hiddenMemos()
    }
    
    // MARK: - internal
    
    var hiddenMemos: [HiddenMemo]
    
    func append(_ hiddenMemo: HiddenMemo) {
        self.hiddenMemos.append(hiddenMemo)
        
        UserDefaultsManager.shared.update(hiddenMemos)
    }
    
    func remove(by id: String) {
        guard let index = self.index(by: id) else {
            return
        }
        
        self.hiddenMemos.remove(at: index)
            
        UserDefaultsManager.shared.update(hiddenMemos)
    }
    
    func index(by id: String) -> Int? {
        guard let value = Int(id) else {
            return nil
        }
        
        var first = 0
        var last = self.hiddenMemos.count
        
        while first <= last {
            let mid = (first + last) / 2
            
            guard let midValue = Int(self.hiddenMemos[mid].id) else {
                return nil
            }
            
            if midValue == value {
                return mid
            }
            
            if midValue > value {
                last = mid - 1
            } else {
                first = mid + 1
            }
        }
        
        return nil
    }
    
    func hiddenMemo(by id: String) -> HiddenMemo? {
        guard let index = self.index(by: id) else {
            return nil
        }
        
        return self.hiddenMemos[index]
    }
    
}
