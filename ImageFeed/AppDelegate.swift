import UIKit
import ProgressHUD

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .ypBlackIOS
        ProgressHUD.colorAnimation = .ypWhiteIOS
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions)
    -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: "Main", sessionRole: connectingSceneSession.role)
        
        sceneConfig.delegateClass = SceneDelegate.self
        
        return sceneConfig
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
}

