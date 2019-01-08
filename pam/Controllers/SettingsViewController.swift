import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let versionNumber: String = "2.0"
    @IBOutlet weak var versionViewLabel: UILabel!
    @IBOutlet weak var sourcesTableView: UITableView!

    let sections = ["General", "Mobile", "Programming", "Video Games"]
    var dictionary = UserDefaults.standard.dictionary(forKey: "selectedSitesDictionary")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true

        versionViewLabel.text = "version: \(versionNumber)"

        sourcesTableView.delegate = self
        sourcesTableView.dataSource = self

        sourcesTableView.tableFooterView = UIView()
    }
    override func viewDidAppear(_ animated: Bool) {
        dictionary = UserDefaults.standard.dictionary(forKey: "selectedSitesDictionary")
        sourcesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var curCategoryArray = dictionary![sections[section]] as! [String]
        curCategoryArray = curCategoryArray.filter { $0 != "" }

        return curCategoryArray.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = sourcesTableView.dequeueReusableCell(withIdentifier: "sourceCell") as! SourceTableViewCell

        var curCategoryArray = dictionary![sections[indexPath.section]] as! [String]
        curCategoryArray = curCategoryArray.filter { $0 != "" }

        cell.sourceLabel.text = curCategoryArray[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            var curCategoryArray = dictionary![sections[indexPath.section]] as! [String]
            curCategoryArray = curCategoryArray.filter { $0 != "" }
            curCategoryArray.remove(at: indexPath.row)

            dictionary?.updateValue(curCategoryArray, forKey: sections[indexPath.section])
            UserDefaults.standard.removeObject(forKey: "selectedSitesDictionary")
            UserDefaults.standard.set(dictionary, forKey: "selectedSitesDictionary")

            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
     }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
