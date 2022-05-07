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
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var usersCountLabel: UILabel!
    
    private var cancellables = Set<AnyCancellable>()
    private var usersRepo: CoreDataRepository<User>?
    @Published private var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUsersRepo()
        setuoUsersTableView()
        subscribeOnUsersChange()
    }
    
    // MARK: - Setup
    
    private func initializeUsersRepo() {
        guard
            let storageContext: CoreDataStorageContextContract = try? CoreDataManager.shared.storageContext()
        else {
            return
        }
        
        usersRepo = CoreDataRepository<User>(coreDataStorageContext: storageContext)
    }
    
    private func setuoUsersTableView() {
        usersTableView.dataSource = self
        usersTableView.delegate = self
    }
    
    private func subscribeOnUsersChange() {
        $users.sink { [weak self] users in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.usersCountLabel.text = "\(users.count)"
                self.usersTableView.reloadData()
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @IBAction func addNewButtonAction(_ sender: UIButton) {
        usersRepo?.insert { user in
            user.id = UUID()
            user.name = String.random(length: 1)
        }
        .sink { completion in
            guard case .failure(let error) = completion else { return }
            print(error.localizedDescription)
        } receiveValue: { [weak self] user in
            guard let self = self else { return }
            self.users.append(user)
        }
        .store(in: &cancellables)
    }
    
    @IBAction func addNew1500UserButtonAction(_ sender: UIButton) {
        for _ in 0..<1500 {
            usersRepo?.insert { user in
                user.id = UUID()
                user.name = String.random(length: 1)
            }
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                print(error.localizedDescription)
            } receiveValue: { user in
                self.users.append(user)
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
                self.users.removeAll()
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
                self.users = users
            }
            .store(in: &cancellables)
    }
    
    @IBAction func fetchAllWithSortButtonAction(_ sender: UIButton) {
        usersRepo?.fetch(sortDescriptors: [.init(keyPath: \User.name, ascending: true)])
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                print(error.localizedDescription)
                
            } receiveValue: { [weak self] users in
                guard let self = self else { return }
                self.users = users
            }
            .store(in: &cancellables)
    }
    
    @IBAction func deleteFirstUser(_ sender: UIButton) {
        guard let firstUser: User = users.first else { return }
        
        usersRepo?.delete(with: firstUser.objectID)
            .sink(receiveCompletion: { completion in
                guard case .failure(let error) = completion else { return }
                print(error.localizedDescription)
                
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.users.remove(at: 0)
            })
            .store(in: &cancellables)
    }
    
    @IBAction func updateFirstUser(_ sender: UIButton) {
        guard let firstUser: User = users.first else { return }
        
        firstUser.name = String.random(length: 2)
        
        usersRepo?.update(firstUser)
            .sink(receiveCompletion: { completion in
                guard case .failure(let error) = completion else { return }
                print(error.localizedDescription)
                
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.users.removeFirst()
                self.users.insert(firstUser, at: 0)
            })
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {}

// MARK: - Helpers

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
