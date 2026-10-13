import UIKit
import Kingfisher

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListService { get set }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func updatePhotosArrayAndTableView()
    func serviceFetchPhotos()
    func updatePhotosArray()
    func changeLike(in cell: ImagesListCell, on photoId: String, from isLiked: Bool, indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    var imagesListService: ImagesListService
    
    init(imageListService: ImagesListService) {
        self.imagesListService = imageListService
    }
    
    func serviceFetchPhotos() {
        imagesListService.fetchPhotosNextPage() { _ in }
    }
    
    func updatePhotosArrayAndTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        updatePhotosArray()
        
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = view as? ImagesListCellDelegate
        
        let photo = photos[indexPath.row]
        
        cell.configCell(with: photo)
    }
    
    func updatePhotosArray() {
        photos = imagesListService.photos
    }
    
    func changeLike(in cell: ImagesListCell, on photoId: String, from isLiked: Bool, indexPath: IndexPath) {
        imagesListService.changeLike(on: photoId, from: isLiked) {[weak self] result in
            switch result {
            case .success:
                self?.updatePhotosArray()
                
                guard let updatedPhoto = self?.photos[indexPath.row] else { return }
                
                cell.likeButton.setImage(UIImage(resource: updatedPhoto.isLiked ? .heartActive : .heartNoActive), for: .normal)
                
            case .failure(let error):
                print("ChangeLikeError: \(error)")
                                
                if "\(error)" == "invalidLikeRequest" {
                    self?.view?.showLikeSpamError()
                } else {
                    self?.view?.showUnknownError()
                }
            }
        }

    }
}
