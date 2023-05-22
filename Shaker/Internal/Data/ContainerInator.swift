//
//  ContainerInator.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 5/14/23.
//

import CoreData

/// Create and store credentials using this easy, completely rewritten struct!
struct ContainerInator {
    
    /// A singleton to properly ensure only one instance is used
    static let shared = ContainerInator()
    
    let container: NSPersistentCloudKitContainer
    
    static var preview: ContainerInator = {
        
        LoggingInator.log(.setup, .function, .info, "Began creating new preview container")
        
        let result = ContainerInator(inMemory: true)
        let viewContext = result.container.viewContext
        
        /// Sample data
        for iteration in 0..<10 {
            let credential = Password(context: viewContext)
            credential.title = "Example Key \(iteration)"
            credential.username = "MyUsername"
            credential.value = "myPassword"
            credential.isPinned = Bool.random()
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            LoggingInator.log(.setup, .function, .error, "Preview container creation failed with error: \(nsError.localizedDescription), and user info: \(nsError.userInfo)")
            fatalError("Core Data error: \(nsError.localizedDescription), \(nsError.userInfo)")
        }
        
        LoggingInator.log(.setup, .function, .info, "Finished creating new preview container")
        
        return result
        
    }()
    
    private init(inMemory: Bool = false) {
        
        LoggingInator.log(.setup, .function, .info, "Began initializing a new (modern) ContainerInator, stored \(inMemory ? "in memory" : "on disk")")
        
        container = NSPersistentCloudKitContainer(name: "Shaker")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(filePath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                LoggingInator.log(.setup, .function, .error, "ContainerInator (modern) initialization failed with error: \(error.localizedDescription), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        LoggingInator.log(.setup, .function, .info, "Finished initializing a new (modern) ContainerInator")
        
    }
    
    /// Save the context, aka, data
    func save() {
        
        LoggingInator.log(.runtime, .function, .info, "Began saving changes made to the (modern) CoreData container")
        
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                LoggingInator.log(.runtime, .function, .info, "Changes were detected, attempting to save them.")
                try context.save()
            }
            catch {
                LoggingInator.log(.runtime, .function, .error, "There was an error saving changes made to the CoreData container: \(error.localizedDescription)")
            }
        }
        else {
            LoggingInator.log(.runtime, .function, .warning, "No changes to the container were detected, not attempting to save")
        }
        
        LoggingInator.log(.runtime, .function, .info, "Finished saving changes made to the (modern) CoreData container")
        
    }
}
