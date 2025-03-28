import Foundation
import CoreData

protocol UserDAO {
    func getUsersWithPagination(perPage: Int, since: Int) -> [User]
    func insertUsers(_ users: [User])
    func deleteAllUsers()
    func getUserByLogin(_ login: String) -> User?
    func updateUser(_ user: User)
    func getAllUsers() -> [User]
}

class UserDAOImpl: UserDAO {
    static let shared = UserDAOImpl()
    
    private let coreDataManager: CoreDataManager
    
    private init() {
        coreDataManager = CoreDataManager.shared
    }
//    
//    // Function to get a list of users with pagination, returning an array of User structs
    func getUsersWithPagination(perPage: Int, since: Int) -> [User] {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        // Calculate the offset based on the page and page size
        fetchRequest.fetchOffset = since
        // Set the fetch limit (number of items per page)
        fetchRequest.fetchLimit = perPage
        
//        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            let users: [User] = userEntities.map { $0.toUser() }
            return users
        } catch {
            DLog.d("Error fetching users with pagination: \(error)")
            return [] // Return an empty array in case of an error
        }
    }
    
    // Function to insert multiple users into Core Data
    func insertUsers(_ users: [User]) {
        let context = coreDataManager.persistentContainer.viewContext
        for user in users {
            let newUser = UserEntity(context: context)
            newUser.id = Int32(user.id)
            newUser.login = user.login
            newUser.avatarUrl = user.avatarUrl
            newUser.htmlUrl = user.htmlUrl
            newUser.location = user.location
            newUser.followers = Int32(user.followers ?? 0)
            newUser.following = Int32(user.following ?? 0)
            coreDataManager.saveContext()
        }
    }
    
    func deleteAllUsers() {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
        
        // Create a delete request
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeCount // Added for better error handling
        
        do {
            try coreDataManager.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
            coreDataManager.saveContext() // Save the changes
        } catch {
            DLog.d("Error deleting all users: \(error)")
            context.reset()  //Rollback changes to preserve datastore
        }
    }
    
    func getUserByLogin(_ login: String) -> User? {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "login == %@", login) // Add a predicate to filter by login
        fetchRequest.fetchLimit = 1 // Only fetch one user
        do {
            if let userEntity = try context.fetch(fetchRequest).first {
                // Convert the UserEntity to a User struct and return it
                return userEntity.toUser()
            } else {
                return nil // Return nil if no user is found
            }
        } catch {
            DLog.d("Error fetching user by login: \(error)")
            return nil // Return nil in case of an error
        }
    }
    
    func updateUser(_ user: User) {
        let context = coreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", user.id) // Search by id, important!
        
        do {
            if let existingUserEntity = try context.fetch(fetchRequest).first {
                existingUserEntity.login = user.login
                existingUserEntity.avatarUrl = user.avatarUrl
                existingUserEntity.htmlUrl = user.htmlUrl
                existingUserEntity.location = user.location
                existingUserEntity.followers = Int32(user.followers ?? 0)
                existingUserEntity.following = Int32(user.following ?? 0)
                coreDataManager.saveContext()
            } else {
                DLog.d("Error: User with ID \(user.id) not found in Core Data.")
            }
        } catch {
            DLog.d("Error updating user: \(error)")
        }
    }
    
    func getAllUsers() -> [User] {
        let context = coreDataManager.persistentContainer.viewContext // Get the managed object context
        let fetchRequest = NSFetchRequest<UserEntity>(entityName: "UserEntity")
//        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let users = try context.fetch(fetchRequest) // Execute the fetch request
            return users.map { userEntity in
                userEntity.toUser()
            }
        } catch {
            DLog.d("Failed to fetch users: \(error)")
            return [] // Return an empty array in case of an error
        }
    }
}

