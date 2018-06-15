import UIKit
import SwiftDate

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var selectedTitle: String?
    private var selectedDescription: String?
    private var selectedLink: String?
    private var selectedImage: String?
    
    var articles: [Article]? = []
    
    let link = "https://newsapi.org/v2/top-headlines?country=us&category=technology&pageSize=100&apiKey=d8e20e6ac3064675a2a9733b2e7c96c1"
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.removeTabbarItemsText()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        fetchArticles()
    }
    
    func fetchArticles() {
        let urlRequest = URLRequest(url: URL(string: self.link)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = [Article]()
            do {
                // swiftlint:disable force_cast
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
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
    
    /*func convertTime() -> String {
        
        let date = Date()
        
        return
    }*/
    
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
        selectedDescription = articles?[indexPath.row].desc ?? ""
        selectedImage = articles?[indexPath.row].imageUrl ?? ""
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToNewsDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNewsDetail" {
            if let destinationVC = segue.destination as? NewsViewController {
                destinationVC.pressedTitle = selectedTitle ?? "Couldn\'t load"
                destinationVC.pressedDescription = selectedDescription ?? "Couldn\'t load"
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
    let poland = Region(tz: TimeZoneName.europeWarsaw, cal: CalendarName.gregorian, loc: LocaleName.polish)

    var date  = dateToEstimate.replacingOccurrences(of: "T", with: " ")
    date = date.replacingOccurrences(of: "Z", with: "")
    let formattedDate = try! DateInRegion(string: "1999-12-31 23:30:00", format: .custom("yyyy-MM-dd HH:mm:ss"), fromRegion: poland)

    
    let dateC = DateInRegion() - 15.minute
    let (colloquial,relevantTime) = try! dateC.colloquialSinceNow()
    
    return colloquial
}
