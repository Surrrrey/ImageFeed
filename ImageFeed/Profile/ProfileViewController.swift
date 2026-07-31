import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileAvatar: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileLogin: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    
    @IBAction func logoutButtonAction(_ sender: Any) {
    }
    
}
