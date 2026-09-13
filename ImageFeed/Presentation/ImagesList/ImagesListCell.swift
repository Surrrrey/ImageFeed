import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    private let gradient = CAGradientLayer()

    // MARK: - Outlets
    
    @IBOutlet var cellImageOutlet: UIImageView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var gradientLayer: UIImageView!
    
    // MARK: - Public Methods
    
    func setupGradient() {
        gradientLayer.image = nil
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.ypBackgroundIOS.cgColor
        ]
        
        gradient.frame = gradientLayer.bounds
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradientLayer.layer.addSublayer(gradient)
    }
}
