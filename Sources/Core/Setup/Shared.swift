//
//  Shared.swift
//  KJPlayer
//
//  Created by abas on 2021/12/15.
//

import Foundation
import ObjectiveC

fileprivate var SharedContext: UInt8 = 0

public protocol SharedInstance: AnyObject {
    associatedtype Player
    static var shared: Player { get set }
}

extension SharedInstance where Player: KJBasePlayer {
    
    public static var shared: Player {
        get {
            return synchronizedSharedInstance {
                if let player = objc_getAssociatedObject(self, &SharedContext) as? Player {
                    return player
                }
                let player = Player.init()
                objc_setAssociatedObject(self, &SharedContext, player, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return player
            }
        }
        set {
            synchronizedSharedInstance {
                objc_setAssociatedObject(self, &SharedContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    public static func deinitShared() {
        synchronizedSharedInstance {
            objc_setAssociatedObject(self, &SharedContext, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    internal static func synchronizedSharedInstance<T>( _ action: () -> T) -> T {
        objc_sync_enter(self)
        let result = action()
        objc_sync_exit(self)
        return result
    }
}
