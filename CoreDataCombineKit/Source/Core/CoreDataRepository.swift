//
//  CoreDataRepository.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import CoreData
import Combine

/// Responsable for the core data operations
public final class CoreDataRepository<Entity: NSManagedObject> {
    private var coreDataStorageContext: CoreDataStorageContextContract?
    
    public init(coreDataStorageContext: CoreDataStorageContextContract) {
        self.coreDataStorageContext = coreDataStorageContext
    }
}

// MARK: - Private Methods

private extension CoreDataRepository {
    var forgroundContext: NSManagedObjectContext {
        guard let forgroundContext = coreDataStorageContext?.getForgroundContext() else {
            fatalError("Coredata forground context is nil")
        }
        
        return forgroundContext
    }
    
    var backgroundContext: NSManagedObjectContext {
        guard let backgroundContext = coreDataStorageContext?.getBackgroundContext() else {
            fatalError("Coredata background context is nil")
        }
        
        return backgroundContext
    }
}

// MARK: - Public Methods

public extension CoreDataRepository {
    /// Fetch all entities of single type from the Core data
    /// - Parameters:
    ///   - sortDescriptors: [NSSortDescriptor]
    ///   - predicate: NSPredicate?
    /// - Returns: AnyPublisher<[Entity], Error>
    ///
    func fetch(
        sortDescriptors: [NSSortDescriptor] = [],
        predicate: NSPredicate? = nil
    ) -> AnyPublisher<[Entity], Error> {
        Deferred { [forgroundContext] in
            Future { promise in
                forgroundContext.performAndWait {
                    let request = Entity.fetchRequest()
                    request.sortDescriptors = sortDescriptors
                    request.predicate = predicate
                    
                    do {
                        let results = try forgroundContext.fetch(request) as! [Entity]
                        promise(.success(results))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Fetch single entity by its id from the Core data
    /// - Parameters:
    ///   - id: NSManagedObjectID
    /// - Returns: AnyPublisher<Entity, Error>
    ///
    func fetchEntity(
        with id: NSManagedObjectID
    ) -> AnyPublisher<Entity, Error> {
        Deferred { [forgroundContext] in
            Future { promise in
                forgroundContext.perform {
                    guard let entity = try? forgroundContext.existingObject(with: id) as? Entity else {
                        promise(.failure(CoreDataManagerError.objectNotFound))
                        return
                    }
                    
                    promise(.success(entity))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Insert new entity to the Core data
    /// - Parameters:
    ///   - body: @escaping (inout Entity) -> Void
    /// - Returns: AnyPublisher<Entity, Error>
    ///
    func insert(
        _ body: @escaping (inout Entity) -> Void
    ) -> AnyPublisher<Entity, Error> {
        Deferred { [backgroundContext] in
            Future  { promise in
                backgroundContext.perform {
                    var entity = Entity(context: backgroundContext)
                    body(&entity)
                    do {
                        try backgroundContext.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Updates an entity to the Core data
    /// - Parameters:
    ///   - entity: Entity
    /// - Returns: AnyPublisher<Void, Error>
    ///
    func update(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Deferred { [backgroundContext] in
            Future { promise in
                backgroundContext.perform {
                    do {
                        try backgroundContext.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Deletes an entity from the Core data
    /// - Parameters:
    ///   - entity: Entity
    /// - Returns: AnyPublisher<Void, Error>
    ///
    func delete(_ entity: Entity) -> AnyPublisher<Void, Error> {
        let objectId: NSManagedObjectID = entity.objectID
        
        Deferred { [backgroundContext] in
            Future { promise in
                guard let entityFromCurrentContext = try? backgroundContext.existingObject(with: objectId) as? Entity else {
                    promise(.failure(CoreDataManagerError.objectNotFound))
                    return
                }
                
                backgroundContext.perform {
                    do {
                        backgroundContext.delete(entityFromCurrentContext)
                        try backgroundContext.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Deletes an entity from the Core data by the entity id
    /// - Parameters:
    ///   - with id: NSManagedObjectID
    /// - Returns: AnyPublisher<Void, Error>
    ///
    func delete(with id: NSManagedObjectID) -> AnyPublisher<Void, Error> {
        Deferred { [backgroundContext] in
            Future { promise in
                guard let entity = try? backgroundContext.existingObject(with: id) as? Entity else {
                    promise(.failure(CoreDataManagerError.objectNotFound))
                    return
                }

                backgroundContext.perform {
                    do {
                        backgroundContext.delete(entity)
                        try backgroundContext.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    /// Deletes all entities for a single type from the core data
    /// - Returns: AnyPublisher<Void, Error>
    ///
    func deleteAll() -> AnyPublisher<Void, Error> {
        Deferred { [backgroundContext] in
            Future { promise in
                guard let entityName: String = Entity.entity().name else {
                    promise(.failure(CoreDataManagerError.entityNameNotFound))
                    return
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                backgroundContext.perform {
                    do {
                        try backgroundContext.execute(deleteRequest)
                        try backgroundContext.save()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

