//
//  DatabaseConfiguration.swift
//  KJPlayer
//
//  Created by abas on 2021/12/14.
//

import Foundation
import CoreData

extension DatabaseManager {
    /// Instance objects
    /// `let data = PlayerVideoData.init(context: DatabaseManager.context)
    public static var context: NSManagedObjectContext {
        get {
            if let ctx = DatabaseManager.Configuration.ctx {
                return ctx
            }
            let ctx = DatabaseManager.Configuration.context()
            return ctx!
        }
    }
}

extension DatabaseManager { struct Configuration { } }

/// Configuration information, please set in the App startup time
extension DatabaseManager.Configuration {
    /// `xcdatamodeld` database name
    static let resourceName = "APlayer"
    
    static var ctx: NSManagedObjectContext? = nil
    
    @available(iOS 10.0, *)
    static func context() -> NSManagedObjectContext? {
        guard let url = contextURL(), let model = NSManagedObjectModel(contentsOf: url) else {
            return nil
        }
        let persisContext = NSPersistentContainer(name: PlayerVideoData.entityName, managedObjectModel: model)
        persisContext.loadPersistentStores(completionHandler: { _, _ in })
        ctx = persisContext.viewContext
        return ctx
    }
    
    static func contextURL(forResource: String = "KJPlayer") -> URL? {
        let bundle: Bundle?
        if let bundlePath = Bundle.main.path(forResource: forResource, ofType: "xcdatamodeld") {
            bundle = Bundle.init(path: bundlePath)
        } else {
            bundle = Bundle.main
        }
        return bundle?.url(forResource: DatabaseManager.Configuration.resourceName, withExtension: "momd")
    }
}
