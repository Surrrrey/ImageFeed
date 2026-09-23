import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Layout Properties
    
    private var singleImage = UIImageView()
    
    private var scrollView = UIScrollView()
    
    private let shareButton = UIButton(type: .custom)
    private let shareButtonWidthAndHeight = 50.0
    
    private let backButton = UIButton(type: .system)
    private let backButtonWidthAndHeight = 24.0
    
    private let backgroundColor = UIColor(resource: .ypBlackIOS)
    // MARK: - Properties
    
    var imageUrl: URL? {
        didSet {
            guard isViewLoaded else { return }
            
        }
    }
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            singleImage.image = image
            
            guard let image else { return }
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    private let minZoomScale = 0.1
    private let maxZoomScale = 1.25
    
    private var marginWidth: Double = 0
    private var marginHeight: Double = 0
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configScrollView()
        configSingleImageView()
        configShareButton()
        configBackButton()
        view.backgroundColor = backgroundColor
        
        scrollView.delegate = self
        
        guard let image else { return }

        singleImage.image = image
        
        rescaleAndCenterImageInScrollView(image: image)
        scrollView.layoutIfNeeded()
    }
    
    // MARK: - Layout Methods
    
    private func configScrollView() {
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
        scrollView.contentMode = .scaleToFill
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configSingleImageView() {
        singleImage.contentMode = .scaleAspectFill
        singleImage.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(singleImage)
    }
    
    private func configShareButton() {
        shareButton.setImage(UIImage(resource: .sharing), for: .normal)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: shareButtonWidthAndHeight),
            shareButton.heightAnchor.constraint(equalToConstant: shareButtonWidthAndHeight),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17)
        ])
        
        let action = UIAction { [weak self] _ in
            guard let image = self?.image else { return }
            let sharePanel = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            
            self?.present(sharePanel, animated: true)
        }
        shareButton.addAction(action, for: .touchUpInside)
    }
    
    private func configBackButton() {
        backButton.setImage(UIImage(resource: .backward), for: .normal)
        backButton.tintColor = UIColor(resource: .ypWhiteIOS)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.widthAnchor.constraint(equalToConstant: backButtonWidthAndHeight),
            backButton.heightAnchor.constraint(equalToConstant: backButtonWidthAndHeight)
        ])
        
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }
        backButton.addAction(action, for: .touchUpInside)
    }
    
    // MARK: - Private Methods
    
    private func rescaleImage(image: UIImage) {
        
        view.layoutIfNeeded()
        
        scrollView.contentSize = image.size
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        guard imageSize.width != 0 else { return }
        let hScale = visibleRectSize.width / imageSize.width
        
        guard imageSize.height != 0 else { return }
        let vScale = visibleRectSize.height / imageSize.height
        
        let calculatedScale = min(hScale, vScale)
        let scale = min(maxZoomScale, max(minZoomScale, calculatedScale))
        
        scrollView.setZoomScale(scale, animated: false)
    }
    
    private func centerImage(image: UIImage) {
        updateMargins()
        
        let x = max((marginWidth) * 0.5, 0)
        let y = max((marginHeight) * 0.5, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        rescaleImage(image: image)
        centerImage(image: image)
    }
    
    private func updateMargins() {
        marginWidth = scrollView.bounds.width - scrollView.contentSize.width
        marginHeight = scrollView.bounds.height - scrollView.contentSize.height
    }
}

// MARK: - Scroll View Delegate

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateMargins()
        
        var insetX = 0.0
        var insetY = 0.0
        
        if marginWidth > 0 {
            insetX = marginWidth / 2
        }
        
        if marginHeight > 0 {
            insetY = marginHeight / 2
        }
        
        let newInset = UIEdgeInsets(top: max(insetY, scrollView.contentInset.top),
                                    left: max(insetX, scrollView.contentInset.left),
                                    bottom: max(insetY, scrollView.contentInset.bottom),
                                    right: max(insetX, scrollView.contentInset.right))
        
        scrollView.contentInset = newInset
    }
}
