import Foundation
import CoreData

//@objc(UserEntity)
//final class UserEntity: NSManagedObject {
//    @NSManaged var id: Int32
//    @NSManaged var login: String
//    @NSManaged var avatarUrl: String
//    @NSManaged var htmlUrl: String
//    @NSManaged var location: String?
//    @NSManaged var followers: Int32
//    @NSManaged var following: Int32
//    
//    func toUser() -> User {
//        return User(
//            login: login,
//            id: Int(id),
//            avatarUrl: avatarUrl,
//            htmlUrl: htmlUrl,
//            location: location,
//            followers: Int(followers),
//            following: Int(following)
//        )
//    }
//}

extension UserEntity {
    func toUser() -> User {
        return User(
            login: login ?? "",
            id: Int(id),
            avatarUrl: avatarUrl ?? "",
            htmlUrl: htmlUrl ?? "",
            location: location,
            followers: Int(followers),
            following: Int(following)
        )
    }
}
