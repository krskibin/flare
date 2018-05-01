import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var rssItems: [RSSItem]?
    
    @IBOutlet weak var newsTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.removeTabbarItemsText()
        
        newsTableView.delegate = self
        newsTableView.dataSource = self
        
        fetchData()
    }
    
    private func fetchData() {
        let urlAddress: String = "https://developer.apple.com/news/rss/news.rss"
        let feedParser = FeedParser()
        feedParser.parseFeed(urlAddress: urlAddress) { (rssItems) in
            self.rssItems = rssItems
            OperationQueue.main.addOperation {
                self.newsTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    func removeTabbarItemsText() {
        if let items = tabBarController?.tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
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
        cell.newsLabel.numberOfLines = 0
        cell.dateLabel.text = rssItems?[indexPath.item].pubDate
        cell.newsImage.image = UIImage(named: "image")
        cell.newsImage.layer.cornerRadius = 8
        return cell
    }
}
