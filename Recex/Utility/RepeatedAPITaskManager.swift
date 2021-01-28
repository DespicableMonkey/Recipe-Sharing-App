//
//  RepeatedAPITaskManager.swift
//  Recex
//
//  Created by Pulkith Paruchuri on 1/26/21.
//

import Foundation
import UIKit

struct RepeatedAPITaskManager {
    static var time : CGFloat? = nil
    static var timer: Timer? = nil

    
    static func start(completion: @escaping(Timer) -> (Void)) {
        if(timer != nil){
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time ?? CGFloat(5)), repeats: false, block: completion)
    }
    static func restart(completion: @escaping(Timer)-> (Void)) {
        if(timer != nil) {
            timer?.invalidate()
        }
        start(completion: completion)
    }
    static func stop() {
        timer?.invalidate()
        timer = nil
    }
}
//App Storage
struct AS {
    static func retrieve(for key : String) -> Any? {
        let ud = UserDefaults.standard
        let value = ud.value(forKey: key)
        return value
    }
    static func set(for key : String, _ value : Any) -> (Void) {
        let ud = UserDefaults.standard
        ud.set(value, forKey: key)
        return
    }
    static func verifyItemExists<T>(for key:String, as type: T.Type, otherwise: T){
        if (AS.retrieve(for: key) as? T) == nil {
            AS.set(for: key, (otherwise as T))
        }
    }
}
