//
//  CoreDataRepository.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import CoreData
import Combine

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
    func fetch(
        sortDescriptors: [NSSortDescriptor] = [],
        predicate: NSPredicate? = nil
    ) -> AnyPublisher<[Entity], Error> {
        Deferred { [forgroundContext] in
            Future { promise in
                forgroundContext.perform {
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
    
    func fetchEntity(
        with id: NSManagedObjectID
    ) -> AnyPublisher<Entity, Error> {
        Deferred { [backgroundContext] in
            Future { promise in
                backgroundContext.perform {
                    guard let entity = try? backgroundContext.existingObject(with: id) as? Entity else {
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
    
    func update(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Deferred { [forgroundContext] in
            Future { promise in
                forgroundContext.perform {
                    do {
                        try forgroundContext.save()
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
    
    func delete(_ entity: Entity) -> AnyPublisher<Void, Error> {
        Deferred { [forgroundContext] in
            Future { promise in
                forgroundContext.perform {
                    do {
                        forgroundContext.delete(entity)
                        try forgroundContext.save()
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
    
    func delete(with id: NSManagedObjectID) -> AnyPublisher<Void, Error> {
        Deferred { [forgroundContext] in
            Future { promise in
                guard let entity = try? forgroundContext.existingObject(with: id) as? Entity else {
                    promise(.failure(CoreDataManagerError.objectNotFound))
                    return
                }
                
                forgroundContext.perform {
                    do {
                        forgroundContext.delete(entity)
                        try forgroundContext.save()
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
    
    func delete(with Id: String) -> AnyPublisher<Void, Error> {
        Deferred { [forgroundContext] in
            Future { promise in
                
                forgroundContext.perform {
                    let request = Entity.fetchRequest()
                    
                    do {
                        let results = try forgroundContext.fetch(request) as! [Entity]
                        
                        guard
                            let entity = results.first(where: {
                                $0.objectID.uriRepresentation().absoluteString == Id
                            })
                        else {
                            promise(.failure(CoreDataManagerError.objectNotFound))
                            return
                        }
                        
                        forgroundContext.delete(entity)
                        try forgroundContext.save()
                        
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
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        Deferred { [backgroundContext] in
            Future { promise in
                guard let entityName: String = Entity.entity().name else {
                    promise(.failure(CoreDataManagerError.entityNameNotFound))
                    return
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                backgroundContext.performAndWait {
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

