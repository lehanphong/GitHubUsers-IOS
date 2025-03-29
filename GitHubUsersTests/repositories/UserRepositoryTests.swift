//
//  RepositoriesTests.swift
//  GitHubUsersTests
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import XCTest
@testable import GitHubUsers

class UserRepositoryTests: XCTestCase {
    
    var userRepository: UserRepositoryImpl!
    var mockUserDAO: MockUserDAO!
    var mockAPIManager: MockAPIManager! // Assuming you have a mock API manager
    
    override func setUp() {
        super.setUp()
        mockUserDAO = MockUserDAO()
        mockAPIManager = MockAPIManager() // Create a mock API manager
        userRepository = UserRepositoryImpl(apiManager: mockAPIManager, userDAO: mockUserDAO)
    }
    
    override func tearDown() {
        userRepository = nil
        mockUserDAO = nil
        mockAPIManager = nil
        super.tearDown()
    }
    
    @MainActor
    func testGetUsersSuccess() async {
        // Given
        let user1 = User(login: "user1", id: 1, avatarUrl: "url1", htmlUrl: "html1", location: "location1", followers: 0, following: 0)
        let user2 = User(login: "user2", id: 2, avatarUrl: "url2", htmlUrl: "html2", location: "location2", followers: 0, following: 0)
        mockUserDAO.insertUsers([user1, user2])
        
        // When
        do {
            let users = try await userRepository.getUsers(perPage: 2, since: 0)
            
            // Then
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(users[0].login, "user1")
            XCTAssertEqual(users[1].login, "user2")
        } catch {
            XCTFail("Expected successful fetch, but got error: \(error)")
        }
    }
    
    @MainActor
    func testGetUserDetailsSuccess() async {
        // Given
        let user = User(login: "user1", id: 1, avatarUrl: "url1", htmlUrl: "html1", location: "location1", followers: 0, following: 0)
        mockUserDAO.insertUsers([user])
        mockAPIManager.mockUser = user // Assuming you have a way to mock the API response
        
        // When
        do {
            let fetchedUser = try await userRepository.getUserDetails(login: "user1")
            
            // Then
            XCTAssertEqual(fetchedUser.login, "user1")
        } catch {
            XCTFail("Expected successful fetch, but got error: \(error)")
        }
    }
    
    @MainActor
    func testRefreshUsersSuccess() async {
        // Given
        let user1 = User(login: "user1", id: 1, avatarUrl: "url1", htmlUrl: "html1", location: "location1", followers: 0, following: 0)
        let user2 = User(login: "user2", id: 2, avatarUrl: "url2", htmlUrl: "html2", location: "location2", followers: 0, following: 0)
        mockAPIManager.mockUsers = [user1, user2] // Mock API response
        
        // When
        do {
            let users = try await userRepository.refreshUsers(perPage: 2, since: 0)
            
            // Then
            XCTAssertEqual(users.count, 2)
            XCTAssertEqual(mockUserDAO.getAllUsers().count, 2) // Ensure users are saved in DAO
        } catch {
            XCTFail("Expected successful refresh, but got error: \(error)")
        }
    }
    
    @MainActor
    func testGetUserByLoginSuccess() async {
        // Given
        let user = User(login: "user1", id: 1, avatarUrl: "url1", htmlUrl: "html1", location: "location1", followers: 0, following: 0)
        mockUserDAO.insertUsers([user])
        
        // When
        let fetchedUser = mockUserDAO.getUserByLogin("user1")
        
        // Then
        XCTAssertEqual(fetchedUser?.login, "user1")
    }
}
