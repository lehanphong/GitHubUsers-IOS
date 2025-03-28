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
                ContentDetailUserView(viewModel: viewModel)
                Spacer()
            } else {
                Text("Loading...")
                    .onAppear {
                        viewModel.getUserDetails(login: username)
                    }
            }
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
    }
}

struct ContentDetailUserView: View {
    @StateObject var viewModel: DetailUserViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            // User Info Card
            if let user = viewModel.user {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        if let url = URL(string: user.avatarUrl) {
                            DAsyncImage(url: url)
                                .frame(width: 96, height: 96)
                                .clipShape(Circle())
                                .padding(.all, 4)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        } else {
                            Color.gray.opacity(0.1)
                                .frame(width: 84, height: 84)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text(user.login)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.black)
                            
                            Divider()
                                .padding(.bottom, 8)
                                .padding(.top, 8)
                            HStack {
                                Image(systemName: "location") //temp image
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
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                .frame(height: 128)

                // Follower and Following Counts
                HStack {
                    Spacer()
                    VStack {
                        ZStack {
                            Color.gray.opacity(0.1) // Background for the icon
                                .frame(width: 50, height: 50) // Adjust size as needed
                                .cornerRadius(25) // Make it circular
                            
                            Image(systemName: "person.2") // Follower icon
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        Text("\(user.followers ?? 0)")
                            .font(.headline)
                        Text("Follower")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    Spacer()
                    VStack {
                        ZStack {
                            Color.gray.opacity(0.1) // Background for the icon
                                .frame(width: 50, height: 50) // Adjust size as needed
                                .cornerRadius(25) // Make it circular
                            
                            Image(systemName: "person.fill") // Follower icon
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        Text("\(user.following ?? 0)")
                            .font(.headline)
                        Text("Following")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity) // Center the HStack

                // Blog Section
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
        .padding()
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
