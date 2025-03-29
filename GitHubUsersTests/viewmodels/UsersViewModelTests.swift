//
//  UsersViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import XCTest
@testable import GitHubUsers

class UsersViewModelTests: XCTestCase {
    
    var viewModel: UsersViewModel!
    var mockRepository: MockUserRepository!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        viewModel = UsersViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchUsersSuccess() async {
        // Given
        let user1 = User(login: "user1", id: 1, avatarUrl: "url1", htmlUrl: "html1", location: "location1", followers: 0, following: 0)
        let user2 = User(login: "user2", id: 2, avatarUrl: "url2", htmlUrl: "html2", location: "location2", followers: 0, following: 0)
        mockRepository.mockUsers = [user1, user2]
        
        // When
        viewModel.loadMore() // Await the asynchronous call
        
        //Give time for the code to run
        try? await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        
        // Then
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users[0].login, "user1")
        XCTAssertEqual(viewModel.users[1].login, "user2")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testFetchUsersFailure() async {
        // Given
        mockRepository.mockError = APIError.invalidURL
        
        // When
        viewModel.loadMore() // Await the asynchronous call
        
        //Give time for the code to run
        try? await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testRefreshUsersSuccess() async {
        // Given
        let user1 = User(login: "user1", id: 1, avatarUrl: "url1", htmlUrl: "html1", location: "location1", followers: 0, following: 0)
        mockRepository.mockUsers = [user1]
        
        // When
        viewModel.refreshUsers() // Await the asynchronous call
        
        //Give time for the code to run
        try? await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        
        // Then
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users[0].login, "user1")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testRefreshUsersFailure() async {
        // Given
        mockRepository.mockError = APIError.invalidData
        
        // When
        viewModel.refreshUsers() // Await the asynchronous call
        
        //Give time for the code to run
        try? await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond
        
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }
}
