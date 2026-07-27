import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Outlets
    
    @IBOutlet var cellImageOutlet: UIImageView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var dateLabelOutlet: UILabel!
}
