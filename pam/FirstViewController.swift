import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var rssItems: [RSSItem]?
    let elements = ["Apple się kończy", "SGS9 jest super", "Xiaomi podbija Polskę"]
    
    @IBOutlet weak var newsTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        fetchData()
    }
    
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(urlAddress: "https://developer.apple.com/news/rss/news.rss") { (rssItems) in
            self.rssItems = rssItems
            OperationQueue.main.addOperation {
                self.newsTableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItem = rssItems else {
            return 0
        }
        return rssItem.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "customCell") as! NewsTableViewCell
        cell.newsLabel.text = rssItems?[indexPath.item].title
        cell.newsImage.image = UIImage(named: "image")
        cell.newsImage.layer.cornerRadius = 8
        return cell
    }
}
