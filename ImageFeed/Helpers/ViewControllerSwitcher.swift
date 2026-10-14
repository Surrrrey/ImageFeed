import UIKit

protocol ViewControllerSwitcherProtocol {
    func switchToNewRootController(newController: UIViewController)
    func presentNavigationRootController(from: UIViewController, _ vc: UIViewController, isHiddenNavigationBar: Bool)
    func pushViewController(from: UIViewController, _ vc: UIViewController)
    func presentViewController(from: UIViewController, _ vc: UIViewController)
}

final class ViewControllerSwitcher: ViewControllerSwitcherProtocol {
    
    func switchToNewRootController(newController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = newController
        window.makeKeyAndVisible()
    }
    
    func presentNavigationRootController(from: UIViewController, _ vc: UIViewController, isHiddenNavigationBar: Bool) {
        let navigationController = UINavigationController(rootViewController: vc)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.isHidden = isHiddenNavigationBar
        
        from.present(navigationController, animated: true)
    }
    
    func pushViewController(from: UIViewController, _ vc: UIViewController) {
        from.navigationController?.navigationBar.isHidden = false
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentViewController(from: UIViewController, _ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.navigationController?.navigationBar.isHidden = false
        from.present(vc, animated: true)
    }
}
