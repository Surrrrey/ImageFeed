import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - Layout Properties
    
    private var tableView = UITableView(frame: .zero, style: .plain)
    private let backgroundColor = UIColor(resource: .ypBlackIOS)
    
    private let placeholderHeight = CGSize(width: 343, height: 252)
    
    // MARK: - Properties
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private var ImagesListServiceObserver: NSObjectProtocol?
    
    private let imagesListService = ImagesListService()
    
    private var photos: [Photo] = []
    
    // MARK: - Mock
    
    private let photosName: [String] = Array(0...19).map{ "\($0)" }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObs()
        
        fetchPhotos()
        updateTableViewAnimated()
        
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
    
    
    // MARK: - Private Methods
    
    private func registerCell() {
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
    private func configDataSourceAndDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.prepareForReuse()
        
        let photo = photos[indexPath.row]
        
        cell.selectionStyle = .none
        cell.backgroundColor = backgroundColor
        
        cell.cellImage.contentMode = .scaleAspectFit
        
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: photo.fullImageURL) { result in
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
        
        if photo.isLiked {
            cell.likeButton.setImage(UIImage(resource: .heartActive), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(resource: .heartNoActive), for: .normal)
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
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
    
    private func fetchPhotos() {
        imagesListService.fetchPhotosNextPage { _ in }
    }
}

// MARK: - DataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else
        { return UITableViewCell() }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

// MARK: - Delegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let image = UIImage(resource: .stub)
        let singleImageViewController = SingleImageViewController()
        singleImageViewController.image = image
        
        singleImageViewController.imageUrl = photo.rawImageURL
        
        singleImageViewController.modalPresentationStyle = .fullScreen
        singleImageViewController.modalTransitionStyle = .crossDissolve
        
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        let imageWidth = image.size.width
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        guard imageWidth != 0 else { return 0 }
        
        let scale = imageViewWidth / imageWidth
        
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard indexPath.row + 1 == imagesListService.photos.count else { return }
        fetchPhotos()
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
                self.updateTableViewAnimated()
            }
    }
}
