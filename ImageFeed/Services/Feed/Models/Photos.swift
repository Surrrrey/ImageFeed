import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let description: String?
    let thumbImageURL: URL
    let lagreImageURL: URL
    let isLiked: Bool
}
