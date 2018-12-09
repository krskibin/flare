import UIKit
import SearchTextField

class NewSourceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var apiKey: String = "d8e20e6ac3064675a2a9733b2e7c96c1"
    var apiCat: String = "science,technology,"
    var filterResults: [String]? = []

    let categories = ["General", "Mobile", "Programming", "Video Games"]

    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var websiteInput: SearchTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchFilterResults()

        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.autoresizesSubviews = false

        websiteInput.theme.cellHeight = 50
        websiteInput.theme.font = UIFont.systemFont(ofSize: 14)
        websiteInput.theme.bgColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.0)
        websiteInput.theme.separatorColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.0)
        websiteInput.maxNumberOfResults = 5

        websiteInput.userStoppedTypingHandler = {
            if let criteria = self.websiteInput.text {
                if criteria.count > 1 {

                    // Show loading indicator
                    self.websiteInput.showLoadingIndicator()

                    var _ = self.searchMoreItemsInBackground(criteria: criteria)

                    // Set new items to filter
                    //self.websiteInput.filterStrings(results)
                    // Hide loading indicator
                    self.websiteInput.stopLoadingIndicator()
                }
            }
        }

        initPickerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initPickerView() {
        let picker: UIPickerView
        picker = UIPickerView(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: 300))
        picker.backgroundColor = .white

        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self

        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 255/255, green: 69/255, blue: 82/255, alpha: 1)
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain,
                                         target: self, action: #selector(NewSourceViewController.donePicker))
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain,
                                           target: self, action: #selector(NewSourceViewController.cancelPicker))

        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true

        categoryInput.inputView = picker
        categoryInput.inputAccessoryView = toolbar

        categoryInput.text = "General"
    }

    @objc func donePicker() {
        categoryInput.resignFirstResponder()
    }

    @objc func cancelPicker() {
        categoryInput.resignFirstResponder()
    }

    func searchMoreItemsInBackground(criteria: String) -> [String] {
        // wyszukaj nowe, pasujące strony
        let results = ["One", "Two", "Three"]
        return results
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {

        if (websiteInput.text)! == "" {
            websiteInput.layer.borderWidth = 2.0
            websiteInput.layer.cornerRadius = 5.0
            websiteInput.layer.borderColor = UIColor(red: 1.00, green: 0.27, blue: 0.32, alpha: 1.0).cgColor
        } else if (categoryInput.text)! == "" {
            categoryInput.layer.borderWidth = 2.0
            categoryInput.layer.cornerRadius = 5.0
            categoryInput.layer.borderColor = UIColor(red: 1.00, green: 0.27, blue: 0.32, alpha: 1.0).cgColor
        } else {
            var dictionary = UserDefaults.standard.dictionary(forKey: "selectedSitesDictionary")
            var curCategoryArray = dictionary![(categoryInput.text)!] as! [String]
            curCategoryArray.append((websiteInput.text)!)
            dictionary?.updateValue(curCategoryArray, forKey: (categoryInput.text)!)
            UserDefaults.standard.removeObject(forKey: "selectedSitesDictionary")
            UserDefaults.standard.set(dictionary, forKey: "selectedSitesDictionary")

            self.dismiss(animated: true, completion: nil)
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow curRow: Int, forComponent component: Int) -> String? {
        return categories[curRow]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow curRow: Int, inComponent component: Int) {
        categoryInput.text = categories[curRow]
    }
    
    func fetchFilterResults() {
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v2/sources?categories=\(apiCat)&apiKey=\(apiKey)")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if error != nil {
                print(error!)
                return
            }
            self.filterResults = [String]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!,
                                                            options: .mutableContainers) as! [String: AnyObject]
                
                if let resultsFromJson = json["sources"] as? [[String: AnyObject]] {
                    for resultFromJson in resultsFromJson {
                        let result = FilterResult()
                        
                        if let name = resultFromJson["name"] as? String {
                            result.name = name
                        }
                        if result.name != nil {
                            self.filterResults?.append(result.name!)
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.websiteInput.filterStrings(self.filterResults ?? ["Loading"])
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
