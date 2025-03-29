//
//  MockApiManager.swift
//  GitHubUsersTests
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import XCTest
@testable import GitHubUsers

class MockAPIManager: APIManager {
    var mockUsers: [User] = []
    var mockUser: User?
    var mockError: Error?

    func get<T: Decodable>(url: URL, headers: [String: String]?) async throws -> T {
        if let error = mockError {
            throw error
        }
        if let user = mockUser as? T {
            return user
        }
        if let users = mockUsers as? T {
            return users
        }
        throw APIError.invalidData
    }

    func post<T: Decodable>(url: URL, body: Data?, headers: [String: String]?) async throws -> T {
        // Implement as needed for your tests
        throw APIError.invalidData
    }

    func put<T: Decodable>(url: URL, body: Data?, headers: [String: String]?) async throws -> T {
        // Implement as needed for your tests
        throw APIError.invalidData
    }

    func patch<T: Decodable>(url: URL, body: Data?, headers: [String: String]?) async throws -> T {
        // Implement as needed for your tests
        throw APIError.invalidData
    }

    func delete<T: Decodable>(url: URL, headers: [String: String]?) async throws -> T {
        // Implement as needed for your tests
        throw APIError.invalidData
    }
}
