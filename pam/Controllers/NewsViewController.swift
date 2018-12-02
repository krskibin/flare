import UIKit
import Alamofire
import Atributika
import JGProgressHUD
import SafariServices

class NewsViewController: UIViewController, UIScrollViewDelegate {
    var pressedTitle: String?
    var pressedLink: String?
    var pressedImage: String?
    
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    let myHud = JGProgressHUD(style: .light)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.scrollsToTop = false
        //self.navigationController?.navigationBar.isTranslucent = true
        self.myHud.textLabel.text = "Loading"
        self.myHud.show(in: self.view)
        
        if pressedImage != "" {
            let imageUrl = URL(string: pressedImage!)
            let data = try? Data(contentsOf: imageUrl!)
            print("POBIERAM DO NOWA")
            topImage.image = UIImage(data: data!)
        }
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        //setTransluscentNavBar()
        
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
            
            self.myHud.dismiss()
        }
        
        titleTextView.text = pressedTitle!
        linkBtn.setTitle(pressedLink!, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func showWebView() {
        let svc = SFSafariViewController(url: URL(string: pressedLink!)!)
        svc.modalPresentationStyle = .overFullScreen
        svc.preferredControlTintColor = Colors.myRed
        present(svc, animated: true, completion: nil)
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
    
    @IBAction func showWBV(_ sender: Any) {
        
        showWebView()

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
