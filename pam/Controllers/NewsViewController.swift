import UIKit

class NewsViewController: UIViewController {
    var pressedTitle: String?
    var pressedLink: String?
    var pressedDescription: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextArea: UITextView!
    @IBOutlet weak var linkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NewsParser(pageUrl: pressedLink!)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear

        titleLabel.text = pressedTitle!
        linkLabel.text = pressedLink!
        descriptionTextArea.text = pressedDescription!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
