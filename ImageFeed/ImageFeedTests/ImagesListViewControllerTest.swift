import XCTest
import Foundation
@testable import ImageFeed

// MARK: -

final class ImagesListPresenterSpy: ImagesListPresenterProtocol  {

    var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    var fetchPhotosIsCalled = false
    var updatePhotosArrayIsCalled = false
    
    var imagesListService = ImagesListService()
    
    func serviceFetchPhotos() {
        fetchPhotosIsCalled = true
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // do nothing
    }
    
    func updatePhotosArrayAndTableView() {
        updatePhotosArrayIsCalled = true
    }
    
    func updatePhotosArray() {
        // do nothing
    }
    
    func changeLike(in cell: ImageFeed.ImagesListCell, on photoId: String, from isLiked: Bool, indexPath: IndexPath) {
        // do nothing
    }
}

// MARK: - TESTS

final class ImagesListTest: XCTestCase {
    
    func testViewControllerCalledFetchPhotos() {
        let view = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        view.presenter = presenter
        presenter.view = view
        
        _ = view.view
        
        XCTAssertTrue(presenter.fetchPhotosIsCalled)
    }
    
    func testViewControllerCalledUpdatePhotosArrayIsCalled() {
        let view = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        view.presenter = presenter
        presenter.view = view
        
        _ = view.view
        
        XCTAssertTrue(presenter.updatePhotosArrayIsCalled)
    }
    
    func testImagesListCellPrepareToReuseSetPlaceholder() {
        let cell = ImagesListCell(style: .default, reuseIdentifier: "ImagesListCell")
        cell.cellImage.image = UIImage(systemName: "person.crop.circle.fill")
        
        cell.prepareForReuse()
        
        XCTAssertTrue(cell.placeholderView.isHidden == false)
    }
    
    
}
