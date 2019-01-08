import UIKit
import Alamofire
import Atributika
import JGProgressHUD
import SafariServices
import WebKit
import UIImageColors

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
                let image = UIImage(data: (data!))
                topImage.image = image
                let colors = image?.getColors()
                navigationController?.navigationBar.tintColor = colors?.primary
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
            let tagName = "img"
            result = result.deleteHTMLTags(tags: ["picture", "source", "style", "script"])
            
            let websiteArray = ["www.theverge.com", "www.thenextweb.com"]
            
            if websiteArray.contains("\(URL(string: self.pressedLink!)!.host!)") {
                result = result.replaceMatched(pattern: "(?i)</?\(tagName)\\b[^<]*>")
            }
            
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
            iframe {
                width: 100%;
                height: 500px;
            }
            img {
            width: 100%;
            }
            </style>
            <div id="body">
            \(result)
            </div>
            """
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
        //print("loaded \(webView.scrollView.contentSize.height)")
        //webView.heightAnchor.constraint(equalToConstant: webView.scrollView.contentSize.height).isActive = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            webView.heightAnchor.constraint(equalToConstant: webView.scrollView.contentSize.height).isActive = true
            webView.isHidden = false
            self.myHud.dismiss()
        })
    }

    @objc func showWebView() {
        let safariVC = SFSafariViewController(url: URL(string: pressedLink!)!)
        safariVC.modalPresentationStyle = .overFullScreen
        safariVC.preferredControlTintColor = Colors.myRed
        present(safariVC, animated: true, completion: nil)
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
    func deleteHTMLTag(tagName: String) -> String {
        return self.replacingOccurrences(of: "(?i)</?\(tagName)\\b[^<]*>", with: "", options: .regularExpression, range: nil)
    }
    
    func deleteHTMLTags(tags: [String]) -> String {
        var mutableString = self
        for tagName in tags {
            mutableString = mutableString.deleteHTMLTag(tagName: tagName)
        }
        return mutableString
    }
    
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            return []
        }
    }
    
    func replaceMatched(pattern: String) -> String {
        if let matched = self.matches(for: pattern).first {
            return self.replacingOccurrences(of: matched, with: "<img>")
        } else {
            return self
        }
    }
}
