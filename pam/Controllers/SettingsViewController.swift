import UIKit

class SettingsViewController: UIViewController {
    let versionNumber: String = "0.5 alpha"
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
