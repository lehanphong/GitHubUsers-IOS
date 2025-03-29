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
            } catch let error as APIError {
                switch error {
                case .invalidURL:
                    DLog.d("Invalid URL error while fetching user details.")
                case .requestFailed(let statusCode, let errorModel):
                    DLog.d("Request failed with status code \(statusCode): \(errorModel?.message ?? "No error message")")
                case .invalidData:
                    DLog.d("Invalid data received while fetching user details.")
                case .decodingError(let decodingError):
                    DLog.d("Decoding error: \(decodingError)")
                case .other(let otherError):
                    DLog.d("An unknown error occurred: \(otherError)")
                }
                user = nil
            } catch {
                user = nil
                DLog.d("Error fetching user details: \(error)")
            }
        }
    }
} 
