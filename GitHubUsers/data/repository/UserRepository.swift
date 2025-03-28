import Foundation

protocol UserRepository {
    func getUsers(perPage: Int, since: Int) async throws -> [User]
    func getUserDetails(loginUsername: String) async throws -> User
}

class UserRepositoryImpl: UserRepository {
    private let apiManager: APIManager
    private let baseURL = "https://api.github.com"
    
    init(apiManager: APIManager = APIManagerImpl.shared) {
        self.apiManager = apiManager
    }
    
    func getUsers(perPage: Int = 20, since: Int = 0) async throws -> [User] {
        guard let url = URL(string: "\(baseURL)/users?per_page=\(perPage)&since=\(since)") else {
            throw APIError.invalidURL
        }
        
        return try await apiManager.get(url: url, headers: [:])
    }
    
    func getUserDetails(loginUsername: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/users/\(loginUsername)") else {
            throw APIError.invalidURL
        }
        
        return try await apiManager.get(url: url, headers: [:])
    }
} 
