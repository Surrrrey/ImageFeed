import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configTabBar()
    }
    
    private func configTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(resource: .activeProfile),
                                                        selectedImage: nil)
        
        self.viewControllers = [imagesListController, profileViewController]
    }
}
