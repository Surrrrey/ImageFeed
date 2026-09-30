import UIKit

final class AlertPresenter {
    
    static let shared = AlertPresenter()
    
    func showOneButtonAlert(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.firstButtonText,
                                   style: .default) { _ in
            model.completion()
        }
        alert.addAction(action)
        
        vc.present(alert, animated: true)
    }
    
    func showTwoButtonAlert(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: model.firstButtonText, style: .default) { _ in
            model.completion()
        }
        
        let cancelAction = UIAlertAction(title: model.cancelButtonText, style: .default)
        
        alert.addAction(firstAction)
        alert.addAction(cancelAction)

        vc.present(alert, animated: true)
    }
}
