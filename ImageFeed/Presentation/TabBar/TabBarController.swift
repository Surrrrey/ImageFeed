import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTabBar()
    }
    
    private func configTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ypBlackIOS
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = .ypWhiteIOS
        tabBar.backgroundColor = .ypBlackIOS
        tabBar.isTranslucent = false
        
        let service = ImagesListService()
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter(imageListService: service)
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        imagesListViewController.tabBarItem = UITabBarItem(title: nil,
                                                       image: UIImage(resource: .noActiveMain).withRenderingMode(.alwaysOriginal),
                                                       selectedImage: UIImage(resource: .activeMain).withRenderingMode(.alwaysOriginal))
        
        let profileViewController = ProfileViewController()
        let profileViewPresenter = ProfileViewPresenter()
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        profileViewController.tabBarItem = UITabBarItem(title: nil,
                                                        image: UIImage(resource: .noActiveProfile).withRenderingMode(.alwaysOriginal),
                                                        selectedImage: UIImage(resource: .activeProfile).withRenderingMode(.alwaysOriginal))
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
