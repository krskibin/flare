//
//  NewSourceViewController.swift
//  Alamofire
//
//  Created by Tobiasz Dobrowolski on 06.05.2018.
//

import UIKit
import SearchTextField

class NewSourceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories = ["General", "Mobile", "Programming", "Video Games"]
    var filterResults: [String] = ["The Verge", "Engadget", "Ars Technica", "Hacker News", "Mashable", "Polygon", "National Geographic", "New Scientist", "Recode", "TechCrunch", "The Next Web", "Wired", "IGN"]

    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var websiteInput: SearchTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.autoresizesSubviews = false
        
        websiteInput.filterStrings(filterResults)
        
        websiteInput.theme.cellHeight = 50
        websiteInput.theme.font = UIFont.systemFont(ofSize: 14)
        websiteInput.theme.bgColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
        websiteInput.theme.separatorColor = UIColor(red:0.91, green:0.91, blue:0.91, alpha:1.0)
        websiteInput.maxNumberOfResults = 5
        
        websiteInput.userStoppedTypingHandler = {
            if let criteria = self.websiteInput.text {
                if criteria.count > 1 {
                    
                    // Show loading indicator
                    self.websiteInput.showLoadingIndicator()
                    
                    var results = self.searchMoreItemsInBackground(criteria: criteria)
                    
                    // Set new items to filter
                    //self.websiteInput.filterStrings(results)
                    print("Wyszukano nowe stronki")
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
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: "donePicker")
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: "cancelPicker")
        
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
            websiteInput.layer.borderColor = UIColor(red:1.00, green:0.27, blue:0.32, alpha:1.0).cgColor
            print("Puste pole tytułu strony")
        } else if (categoryInput.text)! == "" {
            categoryInput.layer.borderWidth = 2.0
            categoryInput.layer.cornerRadius = 5.0
            categoryInput.layer.borderColor = UIColor(red:1.00, green:0.27, blue:0.32, alpha:1.0).cgColor
        } else {
            var dictionary = UserDefaults.standard.dictionary(forKey: "selectedSitesDictionary")
            var curCategoryArray = dictionary![(categoryInput.text)!] as! [String]
            curCategoryArray.append((websiteInput.text)!)
            
            print("Tablica ze źródłami danej kategorii po dodaniu nowej: \(curCategoryArray)")
            
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
}
