import Foundation

struct User: Decodable, Identifiable {
    let login: String
    let id: Int
    let avatarUrl: String
    let htmlUrl: String
    let location: String?
    let followers: Int?
    let following: Int?
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case location
        case followers
        case following
    }
} 
