import Foundation
import SwiftUI

@MainActor
class UsersViewModel: ObservableObject {
    private let repository: UserRepository
    private var currentPage = 0
    private let perPage = 20
    
    @Published private(set) var users: [User] = []
    @Published private(set) var isLoading = false
    
    init(repository: UserRepository) {
        self.repository = repository
        DLog.d("UsersViewModel init")
        Task {
            await fetchUsers()
        }
    }
    
    private func fetchUsers() async {
        DLog.d("UsersViewModel fetchUsers currentPage:\(currentPage) \(isLoading)")
        guard !isLoading else {
            return
        }
        do {
            isLoading = true
            let result = try await repository.getUsers(perPage: perPage, since: currentPage * perPage)
            if result.count > 0 {
                users.append(contentsOf: result)
                currentPage += 1
            }
        } catch let error as APIError {
            switch error {
            case .invalidURL:
                DLog.e("Invalid URL error while fetching users.")
            case .requestFailed(let statusCode, let errorModel):
                DLog.e("Request failed with status code \(statusCode): \(errorModel?.message ?? "No error message")")
            case .invalidData:
                DLog.e("Invalid data received while fetching users.")
            case .decodingError(let decodingError):
                DLog.e("Decoding error: \(decodingError)")
            case .other(let otherError):
                DLog.e("An unknown error occurred: \(otherError)")
            }
        } catch {
            DLog.e("Error fetching users: \(error)")
        }
        isLoading = false
    }
    
    private func refreshUsers() async {
        DLog.d("UsersViewModel refreshUsers currentPage:\(currentPage) \(isLoading)")
        guard !isLoading else {
            return
        }
        currentPage = 0
        users = []
        do {
            isLoading = true
            let result = try await repository.refreshUsers(perPage: perPage, since: currentPage * perPage)
            if result.count > 0 {
                users.append(contentsOf: result)
                currentPage += 1
            }
        } catch let error as APIError {
            switch error {
            case .invalidURL:
                DLog.e("Invalid URL error while refreshing users.")
            case .requestFailed(let statusCode, let errorModel):
                DLog.e("Request failed with status code \(statusCode): \(errorModel?.message ?? "No error message")")
            case .invalidData:
                DLog.e("Invalid data received while refreshing users.")
            case .decodingError(let decodingError):
                DLog.e("Decoding error: \(decodingError)")
            case .other(let otherError):
                DLog.e("An unknown error occurred: \(otherError)")
            }
        } catch {
            DLog.e("Error refreshing users: \(error)")
        }
        isLoading = false
    }
    
    func refreshUsers() {
        Task {
            await refreshUsers()
        }
    }
    
    func loadMore() {
        Task {
            DLog.d("UsersViewModel loadMore")
            await fetchUsers()
        }
    }
}
