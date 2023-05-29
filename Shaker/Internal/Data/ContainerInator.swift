//
//  ContainerInator.swift
//  Shaker
//
//  Created by Gabriel Hassebrock on 5/14/23.
//

import Combine
import CoreData

/// Create and store credentials using this easy, completely rewritten class!
class ContainerInator {
    
    /// A singleton to properly ensure only one instance is used
    static let shared = ContainerInator()
    
    let container: NSPersistentCloudKitContainer
    
    private var subscriptions: Set<AnyCancellable> = []
    private let appTransactionAuthorName = "app"
    
    private init(inMemory: Bool = false) {
        
        LoggingInator.log(.setup, .function, .info, "###\(#function) Began initializing a new (modern) ContainerInator, stored \(inMemory ? "in memory" : "on disk")")
        
        container = NSPersistentCloudKitContainer(name: "Shaker")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(filePath: "/dev/null")
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            LoggingInator.log(.setup, .function, .error, "ContainerInator (modern) initialization failed during description setup with error")
            fatalError("ContainerInator (modern) initialization failed during description setup with error")
        }
        
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                LoggingInator.log(.setup, .function, .error, "ContainerInator (modern) initialization failed with error: \(error.localizedDescription), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        do {
            try container.viewContext.setQueryGenerationFrom(.current)
        }
        catch {
            LoggingInator.log(.setup, .function, .error, "Failed to pin the viewContext to the current generation with error: \(error.localizedDescription)")
        }
        
        NotificationCenter.default
            .publisher(for: .NSPersistentStoreRemoteChange)
            .sink {
                self.storeRemoteChange($0)
            }
            .store(in: &subscriptions)
        
        LoggingInator.log(.setup, .function, .info, "Began reading previous history token from token file")
        
        if let tokenData = try? Data(contentsOf: tokenFile) {
            do {
                lastHistoryToken = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
            } catch {
                LoggingInator.log(.setup, .function, .error, "Estabishing the tokenData failed with error (failed Unarchiving): \(error.localizedDescription)")
                fatalError("Estabishing the tokenData failed with error: \(error.localizedDescription)")
            }
        }
        
        LoggingInator.log(.setup, .function, .info, "Finished reading previous history token from token file")
        
        LoggingInator.log(.setup, .function, .info, "Finished initializing a new (modern) ContainerInator")
        
    }
    
    /// Track the last history token processed for a store, and write the value to a file
    private var lastHistoryToken: NSPersistentHistoryToken? = nil {
        didSet {
            LoggingInator.log(.setup, .function, .info, "Began writing the latest history token to file")
            guard let token = lastHistoryToken,
                  let data = try? NSKeyedArchiver.archivedData( withRootObject: token, requiringSecureCoding: true) else { return }
            
            do {
                try data.write(to: tokenFile)
            } catch {
                LoggingInator.log(.setup, .function, .error, "Failed to write the toke data with error: \(error.localizedDescription)")
                fatalError("###\(#function): Failed to write the toke data with error: \(error.localizedDescription)")
            }
            LoggingInator.log(.setup, .function, .info, "Finished writing the latest history token to file")
        }
    }
    
    /// The file URL to store the persistent history token
    private lazy var tokenFile: URL = {
        LoggingInator.log(.setup, .function, .info, "Began identifying the file path to write persistent history tokens to")
        let url = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("CoreDataCloudKitDemo", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                LoggingInator.log(.setup, .function, .error, "Could not identify the file URL with error: \(error.localizedDescription)")
                print("###\(#function): Failed to create persistent container URL. Error = \(error)")
            }
        }
        LoggingInator.log(.setup, .function, .info, "Finished identifying the file path to write persistent history tokens to with path: \(url.appending(component: "token.data"))")
        return url.appendingPathComponent("token.data")
    }()
    
    /// An operation queue for handling history, watching for changes, and triggering UI updates
    private lazy var historyQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
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
    
    @objc
    func storeRemoteChange(_ notification: Notification) {
        // Process persistent history to merge changes from other coordinators.
        historyQueue.addOperation {
            self.processPersistentHistory()
        }
    }
    
    func processPersistentHistory() {
        let backgroundContext = container.newBackgroundContext()
        backgroundContext.performAndWait {
            
            // Fetch history received from outside the app since the last token
            let historyFetchRequest = NSPersistentHistoryTransaction.fetchRequest!
            historyFetchRequest.predicate = NSPredicate(format: "author != %@", appTransactionAuthorName)
            let request = NSPersistentHistoryChangeRequest.fetchHistory(after: lastHistoryToken)
            request.fetchRequest = historyFetchRequest
            
            let result = (try? backgroundContext.execute(request)) as? NSPersistentHistoryResult
            guard let transactions = result?.result as? [NSPersistentHistoryTransaction],
                  !transactions.isEmpty
            else { return }
            
            print("transactions = \(transactions)")
            self.mergeChanges(from: transactions)
            
            // Update the history token using the last transaction.
            lastHistoryToken = transactions.last!.token
        }
    }
    
    private func mergeChanges(from transactions: [NSPersistentHistoryTransaction]) {
        let context = container.newBackgroundContext()
        context.perform {
            transactions.forEach { transaction in
                guard let userInfo = transaction.objectIDNotification().userInfo else {
                    return
                }
                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: userInfo, into: [context])
            }
        }
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
