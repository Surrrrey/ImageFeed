import UIKit
import Kingfisher

protocol ImageListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListService { get set }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func updatePhotosArrayAndTableView()
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    var imagesListService: ImagesListService
    
    init(imageListService: ImagesListService) {
        self.imagesListService = imageListService
    }
    
    func updatePhotosArrayAndTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = view as? ImagesListCellDelegate
        
        let photo = photos[indexPath.row]
        
        cell.configCell(with: photo)
    }
}
