import Foundation

struct ProfileImageResult: Codable {
    let profileImage: [String: URL]?
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
