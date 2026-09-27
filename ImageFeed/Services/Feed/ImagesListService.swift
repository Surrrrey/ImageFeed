import UIKit

private enum ImagesListServiceError: Error {
    case invalidImagesRequest
    case invalidImagesObjectTask
    case invalidSetLikeRequest
    case invalidDeleteLikeRequest
    case invalidLikeRequest
}

final class ImagesListService {
    
    // MARK: - Properties
    
    private(set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    private var sessionTask: URLSessionTask?
    
    private var isCreatingLikeChangeTaskWithThisId = [String]()
    

    private let storage = OAuth2TokenStorage.shared
    
    // MARK: - Public Methods
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        if sessionTask != nil {
            sessionTask?.cancel()
        }
        
        guard let request = makeImagesRequest() else {
            completion(.failure(ImagesListServiceError.invalidImagesRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            
            self?.sessionTask = nil
            
            switch result {
            case .success(let result):
                let photosArray = result.map { element in
                    Photo(
                        id: element.id,
                        size: CGSize(width: element.width, height: element.height),
                        createdAt: element.createdAt,
                        description: element.description,
                        regularImageURL: element.urls.regular, // Взял ссылку regular чтобы картинки не были шакальными
                        fullImageURL: element.urls.full,
                        isLiked: element.isLiked)
                }
                self?.photos.append(contentsOf: photosArray)
                completion(.success(photosArray))
                
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: [NotificationKeys.photos: self?.photos as Any])
                
            case .failure(let error):
                print("ImagesListTaskError: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        self.sessionTask = task
        task.resume()
    }
    
    func changeLike(on photoId: String, from isLiked: Bool, _ completion: @escaping (Result<Photo, Error>) -> Void) {
        if isCreatingLikeChangeTaskWithThisId.firstIndex(where: { $0 == photoId }) != nil {
            completion(.failure(ImagesListServiceError.invalidLikeRequest))
            return
        }
        isCreatingLikeChangeTaskWithThisId.append(photoId)
        
        var request: URLRequest
        
        if isLiked {
            guard let createRequest = makeDeleteLikeRequest(on: photoId)
            else {
                deleteIdFromArray(id: photoId)
                completion(.failure(ImagesListServiceError.invalidDeleteLikeRequest))
                return
            }
            request = createRequest
        } else {
            guard let createRequest = makeSetLikeRequest(on: photoId)
            else {
                deleteIdFromArray(id: photoId)
                completion(.failure(ImagesListServiceError.invalidSetLikeRequest))
                return }
            request = createRequest
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResponseResult, Error>) in
            switch result {
            case .success(let photoResult):
                let newPhoto =
                    Photo(
                        id: photoResult.photo.id,
                        size: CGSize(width: photoResult.photo.width, height: photoResult.photo.height),
                        createdAt: photoResult.photo.createdAt,
                        description: photoResult.photo.description,
                        regularImageURL: photoResult.photo.urls.regular,
                        fullImageURL: photoResult.photo.urls.full,
                        isLiked: photoResult.photo.isLiked)
                
                self?.updatePhoto(with: newPhoto)
                completion(.success(newPhoto))
            case .failure(let error):
                print("ChangeLikeTaskError: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self?.deleteIdFromArray(id: photoId)
        }
        
        task.resume()
    }
    
    // MARK: - Private Methods
    
    private func makeImagesRequest() -> URLRequest? {
        guard
            let imagesUrl = URL(string: Constants.defaultBaseURLString + Constants.photoList)
        else { print("URLForImagesListRequestConfigureError")
            return nil }
        
        guard let token = storage.accessToken else { print("MakeImagesRequestError: Token = nil")
            return nil }
        
        var request = URLRequest(url: imagesUrl)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if
            lastLoadedPage == nil {
            let actualLoadedPage = 1
            lastLoadedPage = actualLoadedPage
            request.setValue(String(actualLoadedPage), forHTTPHeaderField: "page")
        } else
        if var lastLoadedPage {
            lastLoadedPage += 1
            request.setValue(String(lastLoadedPage), forHTTPHeaderField: "page")
        }
        
        return request
    }
    
    private func makeSetLikeRequest(on photoId: String) -> URLRequest? {
        let request = createRequestForLikeChange(for: photoId)
        
        guard var request else { print("CreateSetLikeRequestError")
            return nil }
        
        request.httpMethod = "POST"
        
        return request
    }
    
    private func makeDeleteLikeRequest(on photoId: String) -> URLRequest? {
        let request = createRequestForLikeChange(for: photoId)
        
        guard var request else { print("CreateSetLikeRequestError")
            return nil }
        
        request.httpMethod = "DELETE"
        
        return request
    }
    
    private func updatePhoto(with newPhoto: Photo) {
        if let index = self.photos.firstIndex(where: { $0.id == newPhoto.id}) {
            self.photos[index] = newPhoto
        }
    }
    
    private func createRequestForLikeChange(for photoId: String) -> URLRequest? {
        guard let photosLikeUrl = URL(string:
                                        Constants.defaultBaseURLString +
                                      Constants.findPhotoFromId +
                                      photoId +
                                      Constants.like
        ) else { print("URLForSetLikeRequestConfigureError")
            return nil }
        
        guard let token = storage.accessToken else { print("MakeSetLikeRequestError: Token = nil")
        return nil }
        
        var request = URLRequest(url: photosLikeUrl)

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func deleteIdFromArray(id: String) {
        let index = self.isCreatingLikeChangeTaskWithThisId.firstIndex(where: { $0 == id })
        if let index {
            self.isCreatingLikeChangeTaskWithThisId.remove(at: index)
        }
    }
}

// MARK: = Notification

extension ImagesListService {
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private enum NotificationKeys {
        static let photos = "Photos"
    }
}
