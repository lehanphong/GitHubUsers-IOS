import Foundation

protocol UserRepository {
    func getUsers(perPage: Int, since: Int) async throws -> [User]
    func getUserDetails(login: String) async throws -> User
    func refreshUsers(perPage: Int, since: Int) async throws -> [User]
}

class UserRepositoryImpl: UserRepository {
    private let apiManager: APIManager
    private let userDAO: UserDAO
    private let baseURL = "https://api.github.com"
    
    init(apiManager: APIManager, userDAO: UserDAO) {
        self.apiManager = apiManager
        self.userDAO = userDAO
    }
    
    func getUsers(perPage: Int = 20, since: Int = 0) async throws -> [User] {
        let cachedUsers = userDAO.getUsersWithPagination(perPage: perPage, since: since)
//        let all = userDAO.getAllUsers() //for test
        if cachedUsers.isEmpty {
            let users = try await fetchUsersFromAPI(perPage: perPage, since: since)
            userDAO.insertUsers(users)
            DLog.d("UserRepositoryImpl -> getUsers users -> first: \(users.first?.id ?? -1)")
            return users
        }
        DLog.d("UserRepositoryImpl -> getUsers cachedUsers -> first: \(cachedUsers.first?.id ?? -1)")
        return cachedUsers
    }
    
    func refreshUsers(perPage: Int = 20, since: Int = 0) async throws -> [User] {
        userDAO.deleteAllUsers()
        let users = try await fetchUsersFromAPI(perPage: perPage, since: since)
        userDAO.insertUsers(users)
        return users
    }
    
    private func fetchUsersFromAPI(perPage: Int, since: Int) async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/users?per_page=\(perPage)&since=\(since)") else {
            throw APIError.invalidURL
        }
        return try await apiManager.get(url: url, headers: [:])
    }
    
    
    func getUserDetails(login: String) async throws -> User {
        if let cachedUser = userDAO.getUserByLogin(login), cachedUser.hasDetailInfo() {
            return cachedUser
        }
        let user = try await fetchUserFromAPI(login: login)
        userDAO.updateUser(user)
        return user
    }
    
    private func fetchUserFromAPI(login: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/users/\(login)") else {
            throw APIError.invalidURL
        }
        return try await apiManager.get(url: url, headers: [:])
    }
}
