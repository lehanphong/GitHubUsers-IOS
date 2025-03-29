import SwiftUI

struct DetailUserView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: DetailUserViewModel
    let username: String
    
    init(viewModel: DetailUserViewModel, username: String) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.username = username
    }
    
    var body: some View {
        VStack {
            if let user = viewModel.user {
                ContentDetailUserView(viewModel: viewModel, user: user)
                Spacer()
            } else {
                LoadingView()
                    .onAppear {
                        viewModel.getUserDetails(login: username)
                    }
            }
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
}

struct ContentDetailUserView: View {
    @StateObject var viewModel: DetailUserViewModel
    let user: User
    
    var body: some View {
        VStack(spacing: 32) {
            UserInfoCard(user: user)
            FollowerFollowingCounts(user: user)
            BlogSection(user: user)
        }
        .padding()
    }
}

struct UserInfoCard: View {
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
                        .padding(.vertical, 8)
                    
                    HStack {
                        Image(systemName: "location")
                        Text(user.location ?? "-")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            .frame(height: 128)
        }
    }
}



struct FollowerFollowingCounts: View {
    let user: User
    
    var body: some View {
        HStack {
            Spacer()
            CountView(count: user.followers ?? 0, title: "Follower", icon: "person.2")
            Spacer()
            CountView(count: user.following ?? 0, title: "Following", icon: "person.fill")
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct CountView: View {
    let count: Int
    let title: String
    let icon: String
    
    var body: some View {
        VStack {
            ZStack {
                Color.gray.opacity(0.1)
                    .frame(width: 50, height: 50)
                    .cornerRadius(25)
                
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.black)
            }
            Text("\(count)")
                .font(.headline)
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.8))
        }
    }
}

struct BlogSection: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Blog")
                .font(.headline)
            Text(user.htmlUrl)
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        let userRepository = UserRepositoryImpl(apiManager: APIManagerImpl.shared, userDAO: UserDAOImpl.shared)
        let vm = DetailUserViewModel(userRepository: userRepository)
        
        DetailUserView(viewModel: vm, username: "mojombo")
            .preferredColorScheme(.light)
    }
}
