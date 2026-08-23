protocol OAuth2StorageProtocol {
    var accessToken: String { get }
    var tokenType: String { get }
    var scope: String { get }
    var createdId: Int { get }
}
