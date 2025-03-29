//
//  DetailUserViewModelTests.swift
//  GitHubUsersTests
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import XCTest
@testable import GitHubUsers
import Combine

// Test class for DetailUserViewModel

class DetailUserViewModelTests: XCTestCase {

    var viewModel: DetailUserViewModel!
    var mockRepository: MockUserRepository!

    @MainActor
    override func setUp() {
        super.setUp()
        mockRepository = MockUserRepository()
        viewModel = DetailUserViewModel(userRepository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    @MainActor
    func testGetUserDetails_Success() async {
        // Given
        let expectedUser = User(login: "testuser", id: 123, avatarUrl: "http://example.com/avatar.jpg", htmlUrl: "http://example.com/profile", location: "Test Location", followers: 100, following: 50)
        mockRepository.mockUser = expectedUser

        // When
        viewModel.getUserDetails(login: "testuser")

        //Give time for the code to run
        try? await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond

        // Then
        XCTAssertNotNil(viewModel.user, "User should not be nil")
        XCTAssertEqual(viewModel.user?.login, "testuser", "Login should match")
        XCTAssertEqual(viewModel.user?.id, 123, "ID should match")
    }

    @MainActor
    func testGetUserDetails_Failure() async {
        // Given
        let expectedError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user"])
        mockRepository.mockError = expectedError

        // When
        viewModel.getUserDetails(login: "testuser")

        //Give time for the code to run
        try? await Task.sleep(nanoseconds: 1_000_000) // 1 millisecond


        // Then
        XCTAssertNil(viewModel.user, "User should be nil")
    }
}
