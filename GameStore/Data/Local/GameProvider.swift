//
//  File.swift
//  GameStore
//
//  Created by Deanu Haratinu on 05/10/23.
//

import CoreData

class GameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Game")
        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }
    
    func    saveGameDetail(gameDetail: GameDetailModel, completion: @escaping(Bool) -> Void) {
        let gameDetailEntity = gameDetail.toGameDetailEntity()
        
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            self.getGameDetailById(gameDetail.id) { gameDetail in
                // if gameDetail nil, save the gameDetail
                if gameDetail != nil {
                    completion(false)
                    return
                }
                
                if let entity = NSEntityDescription.entity(forEntityName: "GameDetail", in: taskContext) {
                    let gameDetail = NSManagedObject(entity: entity, insertInto: taskContext)
                    gameDetail.setValue(gameDetailEntity.id, forKey: "id")
                    gameDetail.setValue(gameDetailEntity.title, forKey: "title")
                    gameDetail.setValue(gameDetailEntity.releaseYear, forKey: "releaseYear")
                    gameDetail.setValue(gameDetailEntity.imageUrl, forKey: "imageUrl")
                    gameDetail.setValue(gameDetailEntity.genre, forKey: "genre")
                    gameDetail.setValue(gameDetailEntity.description, forKey: "desc")
                    gameDetail.setValue(gameDetailEntity.rating, forKey: "rating")
                    gameDetail.setValue(gameDetailEntity.platform, forKey: "platform")
                    
                    do {
                        try taskContext.save()
                        completion(true)
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                }
            }
        }
    }
    
    func deleteGameDetailById(_ id: String, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameDetail")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
    
    func getGameDetailById(_ id: String, completion: @escaping(GameDetailModel?) -> Void) {
        let taskContext = newTaskContext()
        
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameDetail")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    let gameDetailEntity = GameDetailEntity(
                        id: result.value(forKeyPath: "id") as? String ?? "",
                        title: result.value(forKeyPath: "title") as? String ?? "",
                        releaseYear: result.value(forKeyPath: "releaseYear") as? String ?? "",
                        rating: result.value(forKeyPath: "rating") as? Float ?? 0.0,
                        imageUrl: result.value(forKeyPath: "imageUrl") as? String ?? "",
                        platform: result.value(forKeyPath: "platform") as? String ?? "",
                        genre: result.value(forKeyPath: "genre") as? String ?? "",
                        description: result.value(forKeyPath: "desc") as? String ?? ""
                    )
                    
                    let gameDetailModel = gameDetailEntity.toGameDetailModel()
                    completion(gameDetailModel)
                } else {
                    completion(nil)
                }
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
                completion(nil)
            }
        }
    }
}
