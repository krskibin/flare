import UIKit
import Alamofire

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let elements = ["Apple się kończy", "SGS9 jest super", "Xiaomi podbija Polskę"]
    
    @IBOutlet weak var newsTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let siteUrl = "https://jsonplaceholder.typicode.com/posts/1"
        Alamofire.request(siteUrl).responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            // swiftlint:disable empty_enum_arguments
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value!)
                }
                
            // swiftlint:disable empty_enum_arguments
            case .failure(_):
                print(response.result.error!)
            }
            
        }
        
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
}
