import UIKit
import FavIcon

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var selectedTitle: String?
    private var selectedLink: String?
    private var selectedImage: String?
    
    private var currentTabButton: UIButton?
    
    var articles: [Article]? = []
    
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var allButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTabButton = allButton
        
        newsTableView.scrollsToTop = false
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        navigationController?.navigationBar.isTranslucent = true
        fetchArticles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.autoresizesSubviews = false
        //fetchArticles()

    }
    
    //swiftlint:disable:next function_body_length
    func fetchArticles(category: String = "All") {
        
        var sourcesString = ""
        let sources = UserDefaults.standard.dictionary(forKey: "selectedSitesDictionary")
        var values: [String]
        
        if category == "All" {
            /* Jeśli funkcja zostaje wywołana dla wszystkich artykułów, to łącze wartości z słownika, tworząc tablicę
               wszystkich stron (+ śmieci w postaci "") */
            values = (sources!["General"] as? [String])! + (sources!["Mobile"] as? [String])! +
                 (sources!["Programming"] as? [String])! + (sources!["Video Games"] as? [String])!
        } else {
            values = (sources![category] as? [String])!
        }
        
        print("Tablica z nazwami stron do przetworzenia: \(values)")
        
        for var source in values where !source.isEmpty {
            source = source.replacingOccurrences(of: " ", with: "-")
            sourcesString.append(source.lowercased())
            sourcesString.append(",")
        }
        
        let link = "https://newsapi.org/v2/top-headlines?sources=\(sourcesString)&apiKey=d8e20e6ac3064675a2a9733b2e7c96c1"
        print(link)
        
        let urlRequest = URLRequest(url: URL(string: link)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!,
                                                            options: .mutableContainers) as! [String: AnyObject]

                if let articlesFromJson = json["articles"] as? [[String: AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        
                        if let title = articleFromJson["title"] as? String,
                           let author = articleFromJson["author"] as? String,
                           let desc = articleFromJson["description"] as? String,
                           let link = articleFromJson["url"] as? String,
                           let pubDate = articleFromJson["publishedAt"] as? String,
                           let urlToImage = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.desc = desc
                            article.headline = title
                            article.link = link
                            article.imageUrl = urlToImage
                            article.pubDate = estimateTime(dateToEstimate: pubDate)
                        }
                        if article.headline != nil {
                            self.articles?.append(article)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.newsTableView.reloadData()
                    if self.newsTableView.visibleCells.isEmpty {
                        print("B Ł Ą D")
                        self.showAlert()
                    }
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Empty space",
                                      message: "No data to show",
                                      preferredStyle: UIAlertControllerStyle.alert)
    
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style {
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let articles = articles else {
            return 0
        }
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "customCell") as! NewsTableViewCell
        
        cell.newsLabel.text = articles?[indexPath.item].headline
        cell.dateLabel.text = articles?[indexPath.item].pubDate
        cell.newsImage.layer.cornerRadius = 8
        cell.newsLabel.numberOfLines = 0
        
        do {
            try FavIcon.downloadPreferred((articles?[indexPath.item].link)!) { result in
            if case let .success(image) = result {
                cell.faviconImage.image = image
            }
        }
        } catch {
            print("error")
        }
        
        if let imageUrl = self.articles?[indexPath.item].imageUrl {
            cell.newsImage.downloadImage(from: (imageUrl))
        } else {
            cell.newsImage.image = UIImage(named: "image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedTitle = articles?[indexPath.row].headline ?? ""
        selectedLink = articles?[indexPath.row].link ?? ""
        selectedImage = articles?[indexPath.row].imageUrl ?? ""
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToNewsDetail", sender: self)
    }
    
    // ScrollView - Tab
    
    func changeTabState(sender: UIButton) {
        sender.isEnabled = false
        sender.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        sender.setTitleColor(UIColor.black, for: .normal)
        
        let scrollWidth = scrollView.frame.width
        let scrollHeight = scrollView.frame.height
        
        let desiredXCoor = sender.frame.origin.x - ((scrollWidth / 2) - (sender.frame.width / 2) )
        let rect = CGRect(x: desiredXCoor, y: 0, width: scrollWidth, height: scrollHeight)
        scrollView.scrollRectToVisible(rect, animated: true)
        
        currentTabButton?.isEnabled = true
        currentTabButton?.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        currentTabButton?.setTitleColor(UIColor.lightGray, for: .normal)
        currentTabButton = sender
        print("Zakończono zmianę UIButton")
    }
    
    @IBAction func allAction(_ sender: UIButton) {
        changeTabState(sender: sender)
        fetchArticles()
    }
    
    @IBAction func generalAction(_ sender: UIButton) {
        changeTabState(sender: sender)
        fetchArticles(category: (sender.titleLabel?.text)!)
    }
    
    @IBAction func mobileAction(_ sender: UIButton) {
        changeTabState(sender: sender)
        fetchArticles(category: (sender.titleLabel?.text)!)
    }
    
    @IBAction func programmingAction(_ sender: UIButton) {
        changeTabState(sender: sender)
        fetchArticles(category: (sender.titleLabel?.text)!)
    }
    
    @IBAction func videoGamesAction(_ sender: UIButton) {
        changeTabState(sender: sender)
        fetchArticles(category: (sender.titleLabel?.text)!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewsDetail" {
            if let destinationVC = segue.destination as? NewsViewController {
                destinationVC.pressedTitle = selectedTitle ?? "Couldn\'t load"
                destinationVC.pressedLink = selectedLink ?? "Coudn\'t load"
                destinationVC.pressedImage = selectedImage ?? ""
            }
        }
    }
}

extension UIImageView {
    func downloadImage(from link: String) {
        let urlRequest = URLRequest(url: URL(string: link)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

func estimateTime(dateToEstimate: String) -> String {
    var date  = dateToEstimate.replacingOccurrences(of: "T", with: " ")
    date  = date.replacingOccurrences(of: "Z", with: "")
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateDate = formatter.date(from: date)
    if dateDate != nil {
        return dateDate!.timeAgoDisplay()
    }
    return dateToEstimate
    
}

extension Date {
    func timeAgoDisplay() -> String {
        // swiftlint:disable identifier_name
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        if secondsAgo < minute {
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours ago"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days ago"
        }
        return "\(secondsAgo / week) weeks ago"
    }

}
