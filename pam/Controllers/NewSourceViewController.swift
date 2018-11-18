//
//  NewSourceViewController.swift
//  Alamofire
//
//  Created by Tobiasz Dobrowolski on 06.05.2018.
//

import UIKit

class NewSourceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories = ["General", "Mobile", "Programming", "Video Games"]
    var sources: [String] = []

    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var websiteInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sources = UserDefaults.standard.array(forKey: "selectedSitesArray") as! [String]
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        
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
        let cancelButton = UIBarButtonItem(title: "Cance;", style: UIBarButtonItemStyle.plain, target: self, action: "cancelPicker")
        
        toolbar.setItems([cancelButton, space, doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        
        categoryInput.inputView = picker
        categoryInput.inputAccessoryView = toolbar
    }
    
    @objc func donePicker() {
        categoryInput.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        categoryInput.resignFirstResponder()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        
        if (websiteInput.text)! == "" {
            websiteInput.layer.borderWidth = 1.0
            websiteInput.layer.cornerRadius = 5.0
            websiteInput.layer.borderColor = UIColor(red:1.00, green:0.27, blue:0.32, alpha:1.0).cgColor
            print("Puste pole tytułu strony")
        } else {
            UserDefaults.standard.removeObject(forKey: "selectedSitesArray")
            sources.append((websiteInput.text)!)
            UserDefaults.standard.set(sources, forKey: "selectedSitesArray")
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
