private enum Constants {
    static let accessKey = "rL-nhFzAjdhJPL4WuRXonwc2BT369H4ksqyKBkHVPuI"
    static let secretKey = "cKlQjhnxlDWPmEV-iooBVobaPlP1HCoLKmwtxnoNpZQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURLString = "https://api.unsplash.com"
    static let receivingCodeAddress = "/oauth/authorize/native"
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
    
    static let userProfile = "/me"
    static let userPublicProfile = "/users/"
    static let photoList = "/photos"
    static let findPhotoFromId = "\(photoList)/"
    static let like = "/like"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    let receivingCodeAddress: String
    let unsplashAuthorizeURLString: String
    let unsplashTokenURLString: String
    let userProfile: String
    let userPublicProfile: String
    let photoList: String
    let findPhotoFromId: String
    let like: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURLString: String,
         receivingCodeAddress: String,
         unsplashAuthorizeURLString: String,
         unsplashTokenURLString: String,
         userProfile: String,
         userPublicProfile: String,
         photoList: String,
         findPhotoFromId: String,
         like: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.receivingCodeAddress = receivingCodeAddress
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.unsplashTokenURLString = unsplashTokenURLString
        self.userProfile = userProfile
        self.userPublicProfile = userPublicProfile
        self.photoList = photoList
        self.findPhotoFromId = findPhotoFromId
        self.like = like
    }
    
    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: Constants.accessKey,
                          secretKey: Constants.secretKey,
                          redirectURI: Constants.redirectURI,
                          accessScope: Constants.accessScope,
                          defaultBaseURLString: Constants.defaultBaseURLString,
                          receivingCodeAddress: Constants.receivingCodeAddress,
                          unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString,
                          unsplashTokenURLString: Constants.unsplashTokenURLString,
                          userProfile: Constants.userProfile,
                          userPublicProfile: Constants.userPublicProfile,
                          photoList: Constants.photoList,
                          findPhotoFromId: Constants.findPhotoFromId,
                          like: Constants.like)
    }
}
