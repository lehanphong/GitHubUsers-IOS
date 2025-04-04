import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel: UsersViewModel
    
    init(viewModel: UsersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.users, id: \.rowId) { user in
//                        UserRow(user: user)
//                            .onAppear {
//                                if user.id == viewModel.users.last?.id, !viewModel.isLoading {
//                                    viewModel.loadMore()
//                                }
//                            }
                        NavigationLink(destination: DetailUserView(viewModel: DetailUserViewModel(userRepository: UserRepositoryImpl(apiManager: APIManagerImpl.shared, userDAO: UserDAOImpl.shared)), username: user.login)) {
                            UserRow(user: user)
                                .onAppear {
                                    if user.id == viewModel.users.last?.id, !viewModel.isLoading {
                                        viewModel.loadMore()
                                    }
                                }
                        }
                    }
                    
                    if viewModel.isLoading {
                        LoadingView() // Use a dedicated loading view
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Github Users")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    refreshButton
                }
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            // Action for back button
            // You can use a presentation mode to dismiss the view if needed
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
    
    private var refreshButton: some View {
        Button(action: {
            viewModel.refreshUsers()
        }) {
            Image(systemName: "arrow.clockwise")
                .foregroundColor(.black)
        }
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                AvatarView(avatarUrl: user.avatarUrl)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(user.login)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                    
                    Divider()
                        .padding(.bottom, 8)
                        .padding(.top, 8)
                    Text(user.htmlUrl)
                        .font(.system(size: 14))
                        .foregroundColor(.blue.opacity(0.8))
                    Spacer()
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .frame(height: 128)
    }
}


#Preview {
    ZStack {
        let user = User(login: "sgasg", id: 2, avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4", htmlUrl: "https://github.com/mojombo", location: "gágasg", followers: 3, following: 5)
        UserRow(user: user)
            .preferredColorScheme(.light)
    }
}



#Preview {
    ZStack {
        let userRepository = UserRepositoryImpl(apiManager: APIManagerImpl.shared, userDAO: UserDAOImpl.shared)
        let usersViewModel = UsersViewModel(repository: userRepository)
    
        UsersView(viewModel: usersViewModel)
            .preferredColorScheme(.light)
    }
}
