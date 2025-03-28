import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel: UsersViewModel
    
    init(viewModel: UsersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.users, id: \.rowId) { user in
                        UserRow(user: user)
                            .onAppear {
                                if user.id == viewModel.users.last?.id, !viewModel.isLoading {
                                    viewModel.loadMore()
                                }
                            }
                    }
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Github Users")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Action for back button
                        // You can use a presentation mode to dismiss the view if needed
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.refreshUsers()
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct UserRow: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                if let url = URL(string: user.avatarUrl) {
                    DAsyncImage(url: url)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.all, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.1)
                        .frame(width: 84, height: 84)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.login)
                        .font(.system(size: 18, weight: .medium))
                        
                    Divider()
                        .padding(.bottom, 4)
                        .padding(.top, 4)
                    Text(user.htmlUrl)
                        .font(.system(size: 14))
                        .foregroundColor(.blue.opacity(0.8))
                    Spacer()
                        .frame(height: 16)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}



//#Preview {
//    // Tạo ModelContainer
//    let userRepository = UserRepositoryImpl(apiManager: APIManagerImpl.shared, userDAO: UserDAOImpl.shared)
//    let usersViewModel = UsersViewModel(repository: userRepository)
//    
//    UsersView(viewModel: usersViewModel)
//        .preferredColorScheme(.light)
//}
