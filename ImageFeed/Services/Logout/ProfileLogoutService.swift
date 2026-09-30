import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() { }
    
    func logout() {
        cleanCookies()
        cleanUserToken()
        cleanPhotosArray()
        cleanProfileData()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
    }
    
    private func cleanUserToken() {
        OAuth2TokenStorage.shared.removeToken()
    }
    
    private func cleanProfileData() {
        ProfileService.shared.removeData()
        ProfileImageService.shared.removeAvatarUrl()
    }
    
    private func cleanPhotosArray() {
        ImagesListService().removePhotosData()
    }
}
