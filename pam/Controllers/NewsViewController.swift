import UIKit

class NewsViewController: UIViewController {
    var pressedTitle: String?
    var pressedLink: String?
    var pressedImage: String?
    var pressedDescription: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var topImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrl = URL(string: pressedImage!)
        let data = try? Data(contentsOf: imageUrl!)
        
        topImage.image = UIImage(data: data!)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear

        titleLabel.text = pressedTitle!
        linkLabel.text = pressedLink!
        descriptionLabel.text = pressedDescription!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
