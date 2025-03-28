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
        } catch {
            DLog.e("\(error)")
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
        } catch {
            DLog.e("\(error)")
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
