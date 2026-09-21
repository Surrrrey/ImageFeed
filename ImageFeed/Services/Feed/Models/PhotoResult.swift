import Foundation

struct PhotoResult: Codable {
    let id: String
    let height: Int
    let width: Int
    let createdAt: Date?
    let description: String?
    let urls: PhotosURLs
    let isLiked: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case height
        case width
        case createdAt = "created_at"
        case description
        case urls
        case isLiked = "liked_by_user"
    }
}

struct PhotosURLs: Codable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}
