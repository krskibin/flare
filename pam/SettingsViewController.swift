import UIKit

class SettingsViewController: UIViewController {
    let versionNumber: Double = 0.1
    @IBOutlet weak var versionViewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        versionViewLabel.text = "version: \(versionNumber)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
