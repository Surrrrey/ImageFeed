import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
    var image: UIImage?
    
    @IBOutlet private weak var singleImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        singleImage.image = image
    }
}
