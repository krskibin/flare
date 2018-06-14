import UIKit

class NewsViewController: UIViewController, UIScrollViewDelegate {
    var pressedTitle: String?
    var pressedLink: String?
    var pressedImage: String?
    var pressedDescription: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pressedImage != "" {
            let imageUrl = URL(string: pressedImage!)
            let data = try? Data(contentsOf: imageUrl!)
        
            topImage.image = UIImage(data: data!)
        }
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        setTransluscentNavBar()
        
        self.scrollView.delegate = self
        
        descriptionTextView.sizeToFit()
        descriptionTextView.isScrollEnabled = false

        titleTextView.text = pressedTitle!
        linkLabel.text = pressedLink!
        descriptionTextView.text = pressedDescription!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTransluscentNavBar() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.navigationController!.navigationBar.isTranslucent = false
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        setTransluscentNavBar()
    }
    
    @IBAction func share(_ sender: Any) {
        
        let someText: String = "Hello want to share text also"
        let objectsToShare: URL = URL(string: "http://www.google.com")!
        let sharedObjects: [AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        //activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook,UIActivityType.postToTwitter,UIActivityType.mail]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}
