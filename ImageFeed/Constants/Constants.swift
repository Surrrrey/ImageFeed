enum Constants {
    static let accessKey = "rL-nhFzAjdhJPL4WuRXonwc2BT369H4ksqyKBkHVPuI";
    static let secretKey = "cKlQjhnxlDWPmEV-iooBVobaPlP1HCoLKmwtxnoNpZQ";
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob";
    static let accessScope = "public+read_user+write_likes";
    static let defaultBaseURLString = "https://api.unsplash.com";
    static let receivingCodeAdress = "/oauth/authorize/native"
    static let userProfile = "/me"
    static let userPublicProfile = "/users/"
    static let photoList = "/photos"
    static let findPhotoFromId = "\(photoList)/"
    static let like = "/like"
}
