import UIKit
import Alamofire
import Atributika
import JGProgressHUD
import SafariServices
import WebKit

class NewsViewController: UIViewController, UIScrollViewDelegate, WKNavigationDelegate {
    var pressedTitle: String?
    var pressedLink: String?
    var pressedImage: String?

    @IBOutlet weak var linkBtn: UIButton!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionWK: WKWebView!
    @IBOutlet weak var thisView: UIView!
    
    let myHud = JGProgressHUD(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionWK.isHidden = true
        
        self.scrollView.scrollsToTop = false
        //self.navigationController?.navigationBar.isTranslucent = true
        self.myHud.textLabel.text = "Loading"
        self.myHud.show(in: self.view)

        if pressedImage != "" {
            let imageUrl = URL(string: pressedImage!)
            let data = try? Data(contentsOf: imageUrl!)
            if data != nil {
                topImage.image = UIImage(data: (data!))
            } else {
                topImage.image = UIImage(named: "placeholder")
            }
        }

        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        //setTransluscentNavBar()

        self.scrollView.delegate = self

        descriptionWK.sizeToFit()
        descriptionWK.scrollView.isScrollEnabled = false
        descriptionWK.navigationDelegate = self

        let parser = Parser(articleLink: "", params: ["": ""])
        parser.performRequest(params: ["url": pressedLink!]) { result, error in
            guard var result = result, error == nil else {
                print(error ?? "")
                return
            }
            result = result.deleteHTMLTag(tag: "picture")
            result = result.deleteHTMLTag(tag: "source")
            result = result.deleteHTMLTag(tag: "style")
            result = result.deleteHTMLTag(tag: "script")

            let style = """
            <style>
            #body {
               font-size: 42px;
               font-family: Arial, sans-serif;
               line-height: 150%;
            }
            p {
                font-size: 42px;
                font-family: Arial, sans-serif;
                line-height: 150%;
            }
            a {
                color: black;
                text-decoration: none;
            }
            img {
            width: 100%;
            }
            </style>
            <div id="body">
            \(result)
            </div>
            """
            // swiftlint:disable identifier_name
            /*let links = Style.foregroundColor(.blue)
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
*/
            self.descriptionWK.loadHTMLString(style, baseURL: nil)
        }

        titleTextView.text = pressedTitle!
        linkBtn.setTitle(pressedLink!, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //webView.heightAnchor.constraint(equalToConstant: webView.scrollView.contentSize.height).isActive = false
        print("loaded \(webView.scrollView.contentSize.height)")
        //webView.heightAnchor.constraint(equalToConstant: webView.scrollView.contentSize.height).isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            webView.heightAnchor.constraint(equalToConstant: webView.scrollView.contentSize.height).isActive = true
            webView.isHidden = false
            self.myHud.dismiss()
        })
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

extension String {
    func deleteHTMLTag(tag:String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tag)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags:[String]) -> String {
        var mutableString = self
        for tag in tags {
            mutableString = mutableString.deleteHTMLTag(tag: tag)
        }
        return mutableString
    }
}
