struct AlertModel {
    let title: String
    var message: String?
    let firstButtonText: String
    var secondButtonText: String?
    let firstCompletion: () -> Void
    var secondCompletion: (() -> Void)?
}
