import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImageListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    // MARK: - Layout Properties
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let backgroundColor = UIColor(resource: .ypBlackIOS)
    
    private let placeholderHeight = CGSize(width: 343, height: 252)
    
    // MARK: - Properties
    
    var navigationHandler: ViewControllerSwitcherProtocol?
    
    var presenter: ImageListPresenterProtocol?
    
    private var ImagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        
        presenter?.imagesListService.fetchPhotosNextPage { _ in }
        presenter?.updatePhotosArrayAndTableView()
        
        view.backgroundColor = backgroundColor
        
        configTableView()
        configDataSourceAndDelegate()
        registerCell()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: - Layout Methods
    
    private func configTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if oldCount != newCount {
            tableView.performBatchUpdates {
                var indexPath: [IndexPath] = []
                for index in oldCount..<newCount {
                    indexPath.append(IndexPath(row: index, section: 0))
                }
                
                tableView.insertRows(at: indexPath, with: .automatic)
            } completion: { _ in }
        }
    }
    
    // MARK: - Private Methods
    
    private func registerCell() {
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
    private func configDataSourceAndDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func calculateCellHeight(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = presenter?.photos[indexPath.row]
        
        guard let image else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        let imageWidth = image.size.width
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        guard imageWidth != 0 else { return 0 }
        
        let scale = imageViewWidth / imageWidth
        
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
        
    }
}

// MARK: - DataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else
        { return UITableViewCell() }
        
        presenter?.configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - Delegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationHandler = ViewControllerSwitcher()
        
        guard let photo = presenter?.photos[indexPath.row],
              let navigationHandler
        else { return }
        
        let singleImageViewController = SingleImageViewController()
        
        singleImageViewController.imageUrl = photo.fullImageURL
        
        navigationHandler.presentViewController(self: self, singleImageViewController)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        calculateCellHeight(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == presenter?.imagesListService.photos.count else { return }
        presenter?.imagesListService.fetchPhotosNextPage { _ in }
    }
}

// MARK: - Cell Delegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = presenter?.photos[indexPath.row]
        
        guard let photo, let presenter else { return }
        
        presenter.imagesListService.changeLike(on: photo.id, from: photo.isLiked) { result in
            switch result {
            case .success:
                presenter.photos = presenter.imagesListService.photos
                
                let updatedPhoto = presenter.photos[indexPath.row]
                
                cell.likeButton.setImage(UIImage(resource: updatedPhoto.isLiked ? .heartActive : .heartNoActive), for: .normal)
                
            case .failure(let error):
                print("ChangeLikeError: \(error)")
                if "\(error)" == "invalidLikeRequest" {
                    AlertPresenter.shared.showOneButtonAlert(in: self,
                                                             model: AlertModel(
                                                                title: "Слишком частые запросы",
                                                                message: "Не жмакай лайк так часто)",
                                                                firstButtonText: "Не буду)") { })
                } else {
                    AlertPresenter.shared.showOneButtonAlert(in: self,
                                                             model: AlertModel(
                                                                title: "Что-то пошло не так(",
                                                                firstButtonText: "ОК") { })
                }
            }
        }
    }
}
// MARK: - Observer

extension ImagesListViewController {
    private func addObs() {
        ImagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                presenter?.updatePhotosArrayAndTableView()
            }
    }
}
