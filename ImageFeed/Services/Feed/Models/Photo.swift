import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let regularImageURL: URL
    let fullImageURL: URL
    let isLiked: Bool
}
