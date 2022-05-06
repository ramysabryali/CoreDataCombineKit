//
//  ViewController.swift
//  CoreDataCombineKitExample
//
//  Created by Ramy Sabry on 06/05/2022.
//

import UIKit
import CoreDataCombineKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var usersCountLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    private var usersRepo: CoreDataRepository<User>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUsersRepo()
    }
    
    private func initializeUsersRepo() {
        guard
            let storageContext: CoreDataStorageContextContract = try? CoreDataManager.shared.storageContext()
        else {
            return
        }
        
        usersRepo = CoreDataRepository<User>(coreDataStorageContext: storageContext)
    }
    
    @IBAction func addNewButtonAction(_ sender: UIButton) {
        usersRepo?.add { user in
            user.id = UUID()
            user.name = String.random(length: 1)
        }
        .sink { completion in
            guard case .failure(let error) = completion else { return }
            print(error.localizedDescription)
        } receiveValue: { _ in
            print("Saving Done")
        }
        .store(in: &cancellables)
    }
    
    @IBAction func addNew1500UserButtonAction(_ sender: UIButton) {
        for _ in 0..<1500 {
            usersRepo?.add { user in
                user.id = UUID()
                user.name = String.random(length: 1)
            }
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                print(error.localizedDescription)
            } receiveValue: { _ in
                print("Saving Done")
            }
            .store(in: &cancellables)
        }
    }
    
    @IBAction func deleteAllButtonAction(_ sender: UIButton) {
        usersRepo?.deleteAll()
            .sink(receiveCompletion: { completion in
                guard case .failure(let error) = completion else { return }
                print(error.localizedDescription)
                
            }, receiveValue: {
                
            })
            .store(in: &cancellables)
    }
    
    @IBAction func fetchAllButtonAction(_ sender: UIButton) {
        usersRepo?.fetch()
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                print(error.localizedDescription)
                
            } receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.usersCountLabel.text = "\(users.count)"
            }
            .store(in: &cancellables)
    }
    
//    @IBAction func fetchAllWithSortButtonAction(_ sender: UIButton) {
//        usersRepo?.fetch(sortDescriptors: [.init(keyPath: \User.name, ascending: true)])
//            .sink { completion in
//                guard case .failure(let error) = completion else { return }
//                print(error.localizedDescription)
//
//            } receiveValue: { [weak self] users in
//                guard let self = self else { return }
//                self.usersCountLabel.text = "\(users.count)"
//            }
//            .store(in: &cancellables)
//    }
}

fileprivate extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
