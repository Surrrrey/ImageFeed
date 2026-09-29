struct AlertModel {
    let title: String
    var message: String?
    let firstButtonText: String
    var cancelButtonText: String?
    let completion: () -> Void
}
