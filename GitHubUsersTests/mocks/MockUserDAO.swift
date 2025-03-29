//
//  MockUserDAO.swift
//  GitHubUsersTests
//
//  Created by Nguyen Tien Duc on 29/3/25.
//

import Foundation
import XCTest
@testable import GitHubUsers

class MockUserDAO: UserDAO {
    var users: [User] = []
    
    func getUsersWithPagination(perPage: Int, since: Int) -> [User] {
        let startIndex = since
        let endIndex = min(since + perPage, users.count)
        return Array(users[startIndex..<endIndex])
    }
    
    func insertUsers(_ users: [User]) {
        self.users.append(contentsOf: users)
    }
    
    func deleteAllUsers() {
        users.removeAll()
    }
    
    func getUserByLogin(_ login: String) -> User? {
        return users.first { $0.login == login }
    }
    
    func updateUser(_ user: User) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        }
    }
    
    func getAllUsers() -> [User] {
        return users
    }
}
