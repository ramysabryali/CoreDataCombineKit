<div align="center">


<img src="Screenshots/logo.png" width="80"> 

<br />

# Core Data Combine Kit
### A light weight library for manipulating the main Core Data actions with Combine framework compatibility.


<br /><br />Dependency managers<br />

<a href="https://cocoapods.org/pods/CoreDataCombineKit"><img alt="Cocoapods compatible" src="https://img.shields.io/cocoapods/v/CoreStore.svg?style=flat&label=Cocoapods" /></a>
<a href="https://swift.org/source-compatibility/#current-list-of-projects"><img alt="Swift Package Manager compatible" src="https://img.shields.io/badge/Swift_Package_Manager-compatible-orange.svg?style=flat" /></a>


<br />

</div>

* **Swift 5.5:** iOS 13.1+ / macOS 10.15+


## Setting up
You need two things:
- A CoreDataStorageContext.
- And a CoreDataRepository.

1- The simplest way to initialize CoreDataCombineKit is using the CoreDataManager if you have one data model file.
- Initialize coreDataStorageContext with your data model file name.
- Bass the context to the CoreDataManager by calling Setup method in the AppDelegate.
```swift
import UIKit
import CoreDataCombineKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let coreDataContext: CoreDataStorageContext = .init(
            fileName: "UserManagement",
            bundle: .main,
            storeType: .sqLiteStoreType
        )
        
        CoreDataManager.setup(coreDataStorageContext: coreDataContext)
        return true
    }
}
```

<br />

2- Or you can initialize your own CoreDataStorageContainer on the CoreDataRepo container like:
```swift
import UIKit
import CoreDataCombineKit
import Combine

class ExampleViewController: UIViewController {
    private let coreDataContext: CoreDataStorageContext = .init(
            fileName: "UserManagement",
            bundle: .main,
            storeType: .sqLiteStoreType
        )
    private lazy var usersRepo = CoreDataRepository<User>(coreDataStorageContext: coreDataContext)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
```

## Usage
- Suppose we have an entity called User.

Adding new entity:

```swift
func addNewUser() {
        usersRepo.insert { user in
            user.id = UUID()
            user.name = "Jhon"
        }
        .sink { completion in
            guard case .failure(let error) = completion else { return }
            print(error.localizedDescription)

        } receiveValue: { _ in
            print("Saving Done")
        }
        .store(in: &cancellables)
    }
```

<br />

Fetching all entities:

```swift
func fetchAllUsers() {
     usersRepo.fetch()
        .sink { completion in
            guard case .failure(let error) = completion else { return }
            print(error.localizedDescription)
                
        } receiveValue: { [weak self] users in
            guard let self = self else { return }
            // Do what you want
        }
        .store(in: &cancellables)
    }
```

<br />

Fetching all entities with sort:

```swift
func fetchAllUsersWithSorting() {
     usersRepo.fetch(sortDescriptors: [.init(keyPath: \User.name, ascending: true)])
        .sink { completion in
            guard case .failure(let error) = completion else { return }
            print(error.localizedDescription)
            
        } receiveValue: { [weak self] users in
            guard let self = self else { return }
            // Do what you want
        }
        .store(in: &cancellables)
    }
```

<br />

Fetching an entity with id:

```swift
func fetchSingleUser() {
     usersRepo.fetchEntity(with: user.id)
        .sink { completion in
            guard case .failure(let error) = completion else { return }
            print(error.localizedDescription)
                
        } receiveValue: { [weak self] user in
            guard let self = self else { return }
            // Do what you want
        }
        .store(in: &cancellables)
    }
```

<br />

Update an entity:

```swift
func updateUser() {
    user.name = "Updated name"

    usersRepo.update(user)
        .sink(receiveCompletion: { completion in
            guard case .failure(let error) = completion else { return }
             print(error.localizedDescription)
            
        }, receiveValue: {
            // Do what you want
        })
        .store(in: &cancellables)
    }
```

<br />

Delete an entity:

```swift
func deleteSingleUser() {
    usersRepo.delete(with: user.objectID)
        .sink(receiveCompletion: { completion in
            guard case .failure(let error) = completion else { return }
             print(error.localizedDescription)
            
        }, receiveValue: {
            // Do what you want
        })
        .store(in: &cancellables)
    }
```

<br />

Delete all entities:

```swift
func deleteAllUsers() {
    usersRepo.deleteAll()
        .sink(receiveCompletion: { completion in
            guard case .failure(let error) = completion else { return }
             print(error.localizedDescription)
            
        }, receiveValue: {
            // Do what you want
        })
        .store(in: &cancellables)
    }
```

<br />


## Architecture
All fetching requests execusting on the main thread with the main context, But insert, update and delete requests are executing on a background thread.

<img src="Screenshots/CoreDataCombineKitDesign.jpeg" width="400"> 

<br />
    
## Installation
- Requires:
    - iOS 13.1 SDK and above
    - Swift 5.0 (Xcode 13+)
- Dependencies:
    - *None*
- Other notes:
    - The fetch requests executes on the main context (Main Thread).
    - Insert, Update, Delete and DeleteAll all are executing on the background context (Background Thread).


### Install with CocoaPods
In your `Podfile`, add
```
pod 'CoreDataCombineKit'
```
and run 
```
pod install
```

if you are using Macbook M1, maybe you will face an error while executing the previous command, so you can try the following commands
```sh
sudo arch -x86_64 gem install ffi
arch -x86_64 pod install
```

<br />

### Install with Swift Package Manager:
```swift
dependencies: [
    .package(url: "https://github.com/ramyaimansabry/CoreDataCombineKit.git", from: "0.0.1"))
]
```

<br />

### Install through Xcode's Swift Package Manager
From the **File** - **Swift Packages** - **Add Package Dependency…** menu, search for 
```
CoreDataCombineKit
```

<br />

## Authors

- [Ramy Sabry](https://www.linkedin.com/in/ramy-aiman-sabry-153770117/)

  

