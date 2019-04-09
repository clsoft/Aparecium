//
//  UserDefaultsManager.swift
//  HiddenMemoAR
//
//  Created by HyungJung Kim on 27/11/2018.
//  Copyright © 2018 HyungJung Kim. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {
        
    }
    
    func hiddenMemos() -> [HiddenMemo] {
        let userDefault = UserDefaults.standard
        let decoder = PropertyListDecoder()
        
        var hiddenMemos: [HiddenMemo] = []
        
        if let hiddenMemosData = userDefault.value(forKey: "SavedHiddenMemos") as? Data {
            do {
                hiddenMemos = try decoder.decode([HiddenMemo].self, from: hiddenMemosData as Data)
            } catch {
                print(error)
            }
        }
        
        return hiddenMemos
    }
    
    func update(_ hiddenMemos: [HiddenMemo]) {
        let userDefault = UserDefaults.standard
        let encoder = PropertyListEncoder()
        
        if let hiddenMemosData = try? encoder.encode(hiddenMemos) {
            userDefault.set(hiddenMemosData, forKey:"SavedHiddenMemos")
        }
    }
    
}
