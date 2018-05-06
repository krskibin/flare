//
//  NewSourceViewController.swift
//  Alamofire
//
//  Created by Tobiasz Dobrowolski on 06.05.2018.
//

import UIKit

class NewSourceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let categories = ["General", "Mobile", "Programming", "Video Games", "Design"]
    
    var pickerView = UIPickerView()

    @IBOutlet weak var categoryInput: UITextField!
    @IBOutlet weak var websiteInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryInput.inputView = pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
        
        categoryInput.setBottomBorder()
        websiteInput.setBottomBorder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        //SettingsViewController.addSources(website: websiteInput.text, category: categoryInput.text)
        self.dismiss(animated: true, completion: nil)
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
        categoryInput.resignFirstResponder()
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
