import UIKit
import Kingfisher

protocol ImageListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
}

final class ImageListPresenter: ImageListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func updateTableViewAnimated() {
        
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.prepareForReuse()
        cell.delegate = view as? ImagesListCellDelegate
                
        let photo = photos[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(resource: .ypBlackIOS)
        
        cell.cellImage.contentMode = .scaleAspectFit
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: photo.regularImageURL) { result in
            switch result {
            case .success:
                cell.hidePlaceholder()
            case .failure:
                break
            }
        }
        
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        cell.likeButton.setImage(UIImage(resource: photo.isLiked ? .heartActive : .heartNoActive), for: .normal)
    }
}
