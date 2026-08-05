import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    
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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var singleImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else { return }
        let sharePanel = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        present(sharePanel, animated: true)
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = minZoomScale
        scrollView.maximumZoomScale = maxZoomScale
        
        guard let image else { return }

        singleImage.image = image
        singleImage.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
        scrollView.layoutIfNeeded()
    }
    
    // MARK: - Private Methods
    
    private func rescaleImage(image: UIImage) {
        
        view.layoutIfNeeded()
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
