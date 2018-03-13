import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let elements = ["Apple się kończy", "SGS9 jest super", "Xiaomi podbija Polskę"]
    
    @IBOutlet weak var newsTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true // duzy NavBar
        
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
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "customCell") as! NewsTableViewCell
        cell.newsLabel.text = elements[indexPath.row]
        cell.newsImage.image = UIImage(named: "image")
        cell.newsImage.layer.cornerRadius = 8
        return cell
    }
    
    func isNumberEven(number: Int) -> Bool {
        if  !(number % 2 == 0) {
            return false
        }
        return true
    }

}
