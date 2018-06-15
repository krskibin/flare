import UIKit
import Alamofire
import Atributika

class NewsViewController: UIViewController, UIScrollViewDelegate {
    var pressedTitle: String?
    var pressedLink: String?
    var pressedImage: String?
    var pressedDescription: String?
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.scrollsToTop = false
        self.navigationController?.navigationBar.isTranslucent = true
        
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

        let parser = Parser(articleLink: "", params: ["": ""])
        parser.performRequest(params: ["url": pressedLink!]) { result, error in
            guard let result = result, error == nil else {
                print(error ?? "")
                return
            }
            
            // swiftlint:disable identifier_name
            let links = Style.foregroundColor(.blue)
            let phoneNumbers = Style.backgroundColor(.yellow)
            let mentions = Style.font(.italicSystemFont(ofSize: 12)).foregroundColor(.black)
            let b = Style("b").font(.boldSystemFont(ofSize: 12))
            let u = Style("u").underlineStyle(.styleSingle)
            let h1 = Style("h2").font(.boldSystemFont(ofSize: 22))
            let all = Style.font(.systemFont(ofSize: 16)).foregroundColor(.black)

            self.descriptionTextView.attributedText = result
                .style(tags: u, b, h1)
                .styleMentions(mentions)
                .styleHashtags(links)
                .styleLinks(links)
                .stylePhoneNumbers(phoneNumbers)
                .styleAll(all)
                .attributedString
        }
        
        titleTextView.text = pressedTitle!
        linkLabel.text = pressedLink!
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
        
        let someText: String = "Check this article."
        let objectsToShare: URL = URL(string: pressedLink!)!
        let sharedObjects: [AnyObject] = [objectsToShare as AnyObject, someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
}
