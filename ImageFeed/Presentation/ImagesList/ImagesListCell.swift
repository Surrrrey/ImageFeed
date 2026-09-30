import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Layout Properties
    
    private let placeholder = UIImage(resource: .stub)
    let placeholderView = UIImageView()
    
    var cellImage = UIImageView()
    private let cornerRadius = 16.0
    private let cellImageBackground = UIColor(resource: .ypWhiteAlpha50IOS)
    
    var likeButton = UIButton()
    private let likeButtonImage = UIImage(resource: .heartNoActive)
    private let likeButtonWidthAndHeight = 44.0
    
    var dateLabel = UILabel()
    
    private let gradient = CAGradientLayer()
    var gradientLayer = UIImageView()
    private let gradientLayerHeight = 30.0
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configCellImage()
        configPlaceholder()
        configLikeButton()
        configDateLabel()
        configGradientLayer()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        
        showPlaceholder()
    }
    
    // MARK: - Layout Methods
    
    private func configPlaceholder() {
        placeholderView.image = placeholder
        placeholderView.contentMode = .center
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(placeholderView)
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func configCellImage() {
        cellImage.layer.cornerRadius = cornerRadius
        cellImage.layer.masksToBounds = true
        cellImage.backgroundColor = cellImageBackground
        
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cellImage)
        
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func configLikeButton() {
        likeButton.setImage(likeButtonImage, for: .normal)
        likeButton.setTitle(nil, for: .normal)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: likeButtonWidthAndHeight),
            likeButton.widthAnchor.constraint(equalToConstant: likeButtonWidthAndHeight),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor)
        ])
        
        let action = UIAction {[weak self] _ in
            guard let self else { return }
            delegate?.imagesListCellDidTapLike(self)
        }
        
        likeButton.addAction(action, for: .touchUpInside)
    }
    
    private func configDateLabel() {
        dateLabel.textColor = .ypWhiteIOS
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            cellImage.trailingAnchor.constraint(greaterThanOrEqualTo: cellImage.trailingAnchor, constant: -8)
        ])
    }
    
    private func configGradientLayer() {
        gradientLayer.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(gradientLayer)
        
        NSLayoutConstraint.activate([
            gradientLayer.heightAnchor.constraint(equalToConstant: gradientLayerHeight),
            gradientLayer.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradientLayer.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradientLayer.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor)
        ])
    }
    
    private func setupGradient() {
        gradientLayer.image = nil
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.ypBackgroundIOS.cgColor
        ]
        
        gradient.frame = gradientLayer.bounds
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        
        gradientLayer.layer.addSublayer(gradient)
    }
    
    private func showPlaceholder() {
        placeholderView.isHidden = false
    }

    // MARK: - Public Methods

    func hidePlaceholder() {
        placeholderView.isHidden = true
    }
    
}
