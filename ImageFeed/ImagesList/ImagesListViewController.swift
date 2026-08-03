import UIKit

final class ImagesListViewController: UIViewController {
    
    // MARK: Properties
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private let singleImageViewId = "ShowSingleImage"
    
    // MARK: - Mock
    
    private let photosName: [String] = Array(0...19).map{ "\($0)" }
    
    // MARK: - Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: - Public Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == singleImageViewId {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: "\(indexPath.row)") else { return }
        
        cell.setupGradient()
        cell.cellImageOutlet.image = image
        cell.dateLabelOutlet.text = dateFormatter.string(from: Date())
        
        if indexPath.row % 2 == 0 {
            cell.likeButtonOutlet.setImage(UIImage(resource: .heartActive), for: .normal)
        } else {
            cell.likeButtonOutlet.setImage(UIImage(resource: .heartNoActive), for: .normal)
        }
    }
    
}

// MARK: - DataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
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
        performSegue(withIdentifier: singleImageViewId, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: "\(indexPath.row)") else { return 0 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageWidth = image.size.width
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        
        guard imageWidth != 0 else { return 0 }
        
        let scale = imageViewWidth / imageWidth
        
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}
