import UIKit
import Alamofire
import Kanna

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let elements = ["Apple się kończy", "SGS9 jest super", "Xiaomi podbija Polskę"]
    
    @IBOutlet weak var newsTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageUrl = "https://spidersweb.pl"
        scrapPage(pageUrl: pageUrl)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true // big NavBar
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "customCell") as! NewsTableViewCell
        cell.newsLabel.text = elements[indexPath.row]
        cell.newsImage.image = UIImage(named: "image")
        cell.newsImage.layer.cornerRadius = 8
        return cell
    }
    
    func scrapPage(pageUrl: String) {
        Alamofire.request(pageUrl).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }
    
    func parseHTML(html: String) {
        // swiftlint:disable identifier_name
        if let doc = try? HTML(html: html, encoding: .utf8) {
            print(doc.body?.innerHTML ?? "")
            for show in doc.css("td[id^='Text']") {
                
                var showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                let regex = try? NSRegularExpression(pattern: "*",
                                                    options: [.caseInsensitive])

                if regex?.firstMatch(in: showString, options: [],
                                    range: NSMakeRange(0, showString.count)) != nil {
                    print(show)
                    showString += show as! String
                    print("\(showString)\n")
                }
            }
        }
    }
}
