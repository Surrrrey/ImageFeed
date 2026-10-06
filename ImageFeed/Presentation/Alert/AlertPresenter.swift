import UIKit

final class AlertPresenter {
    
    static let shared = AlertPresenter()
    
    func showOneButtonAlert(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.firstButtonText,
                                   style: .default) { _ in
            model.firstCompletion()
        }
        alert.addAction(action)
        
        vc.present(alert, animated: true)
    }
    
    func showTwoButtonAlert(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: model.firstButtonText, style: .default) { _ in
            model.firstCompletion()
        }
        
        let secondAction = UIAlertAction(title: model.secondButtonText, style: .default) { _ in
            if let completion = model.secondCompletion {
                completion() }
        }
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)

        vc.present(alert, animated: true)
    }
}
