import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let versionNumber: String = "0.5 alpha"
    @IBOutlet weak var versionViewLabel: UILabel!
    @IBOutlet weak var sourcesTableView: UITableView!
    
    var sources: [String] = ["Engadget", "The Verge", "IGN", "9to5Mac"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionViewLabel.text = "version: \(versionNumber)"
        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sourcesTableView.dequeueReusableCell(withIdentifier: "sourceCell") as! SourceTableViewCell
        cell.sourceLabel.text = sources[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     
        if editingStyle == .delete {
         sources.remove(at: indexPath.row)
            
         tableView.beginUpdates()
         tableView.deleteRows(at: [indexPath], with: .automatic)
         tableView.endUpdates()
     }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func addSources(website: String, category: String) {
        sources.append(website)
    }
}
