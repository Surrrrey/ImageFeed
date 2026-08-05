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
    
    // MARK: - Outlets
    
    @IBOutlet private weak var singleImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        //todo
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
        let oldContentSize = scrollView.bounds.size
        
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - oldContentSize.width) / 2
        let y = (newContentSize.height - oldContentSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        rescaleImage(image: image)
        centerImage(image: image)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
    
    func scrollViewDidEndZooming(_: UIScrollView, with: UIView?, atScale: CGFloat) {
        guard let image else { return }
        if scrollView.bounds.width < image.size.width {
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
}
