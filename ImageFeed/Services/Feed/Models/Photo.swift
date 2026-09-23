import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let fullImageURL: URL
    let rawImageURL: URL
    let isLiked: Bool
}
