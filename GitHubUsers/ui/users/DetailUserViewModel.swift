import Foundation
import Combine

@MainActor
class DetailUserViewModel: ObservableObject {
    private let userRepository: UserRepository
    @Published private(set) var user: User?

    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    func getUserDetails(login: String) {
        Task {
            do {
                let userDetails = try await userRepository.getUserDetails(login: login)
                user = userDetails
            } catch {
                user = nil
                print("Error fetching user details: \(error)")
            }
        }
    }
} 
