//
//  GitHubUsersApp.swift
//  GitHubUsers
//
//  Created by Nguyen Tien Duc on 28/3/25.
//

import SwiftUI
import CoreData

@main
struct GitHubUsersApp: App {
    var body: some Scene {
        WindowGroup {
            let userRepository = UserRepositoryImpl(apiManager: APIManagerImpl.shared, userDAO: UserDAOImpl.shared)
            let usersViewModel = UsersViewModel(repository: userRepository)
            UsersView(viewModel: usersViewModel)
        }
    }
}
