import UIKit

protocol ViewControllerSwitcherProtocol {
    func switchToNewRootController(newController: UIViewController)
    func presentNavigationRootController(self: UIViewController, _ vc: UIViewController, isHiddenNavigationBar: Bool)
    func pushViewController(self: UIViewController, _ vc: UIViewController)
    func presentViewController(self: UIViewController, _ vc: UIViewController)
}

final class ViewControllerSwitcher: ViewControllerSwitcherProtocol {
    
    func switchToNewRootController(newController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let newViewController = newController
        window.rootViewController = newViewController
        window.makeKeyAndVisible()
    }
    
    func presentNavigationRootController(self: UIViewController, _ vc: UIViewController, isHiddenNavigationBar: Bool) {
        let navigationController = UINavigationController(rootViewController: vc)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = isHiddenNavigationBar
        
        self.present(navigationController, animated: true)
    }
    
    func pushViewController(self: UIViewController, _ vc: UIViewController) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(self: UIViewController, _ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.navigationController?.navigationBar.isHidden = false
        self.present(vc, animated: true)
    }
}
