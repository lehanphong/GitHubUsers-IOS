//
//  MockUserRepository.swift
//  GitHubUsersTests
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import XCTest
@testable import GitHubUsers

// Mock UserRepository for testing
class MockUserRepository: UserRepository {
    
    var mockUsers: [User] = []
    var mockUser: User?
    var mockError: Error?
    
    func getUserDetails(login: String) async throws -> User {
        if let error = mockError {
            throw error
        }
        if let user = mockUser {
            return user
        } else {
            throw NSError(domain: "MockError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No user provided in mock."])
        }
    }
    
    
    func getUsers(perPage: Int, since: Int) async throws -> [User] {
        if let error = mockError {
            throw error
        }
        
        // Simulate pagination
        let startIndex = since
        let endIndex = min(since + perPage, mockUsers.count) // Don't go out of bounds
        
        if startIndex >= mockUsers.count {
            return [] // Return an empty array if the start index is out of bounds
        }
        
        return Array(mockUsers[startIndex..<endIndex])
    }
    
    func refreshUsers(perPage: Int, since: Int) async throws -> [User] {
        if let error = mockError {
            throw error
        }
        
        // Simulate pagination
        let startIndex = since
        let endIndex = min(since + perPage, mockUsers.count) // Don't go out of bounds
        
        if startIndex >= mockUsers.count {
            return [] // Return an empty array if the start index is out of bounds
        }
        
        return Array(mockUsers[startIndex..<endIndex])
    }
}
