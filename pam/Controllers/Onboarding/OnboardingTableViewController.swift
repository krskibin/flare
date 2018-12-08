//
//  OnboardingTableViewController.swift
//  pam
//
//  Created by Tobiasz Dobrowolski on 07.06.2018.
//  Copyright © 2018 Krystian Skibiński. All rights reserved.
//

import UIKit

class OnboardingTableViewController: UITableViewController {

    let section = ["General", "Mobile", "Programming", "Video Games"]
    let sites = [["The Verge", "Engadget", "Wired", "Mashable"],
                 ["The Next Web", "TechRadar"],
                 ["Hacker News", "Recode"],
                 ["IGN", "Polygon"]]

    var selectedSites = ["General": [""],
                         "Mobile": [""],
                         "Programming": [""],
                         "Video Games": [""]]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func endOnboarding(_ sender: Any) {
        UserDefaults.standard.set(selectedSites, forKey: "selectedSitesDictionary")
        print(selectedSites)
        UserDefaults.standard.set(true, forKey: "FIRST_TIME")
        performSegue(withIdentifier: "MainView", sender: nil)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.section.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.sites[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onboardingCell", for: indexPath) as? OnboardingTableViewCell
        cell?.textLabel?.text = sites[indexPath.section][indexPath.row]
        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell?.accessoryType = UITableViewCellAccessoryType.none
            var curArray = selectedSites[section[indexPath.section]]
            print("Zaznaczone strony z danej kategorii: \(curArray!)")
            curArray = curArray?.filter { $0 != sites[indexPath.section][indexPath.row] }
            print("Zaznaczone strony z danej kategorii po usunięciu: \(curArray!)")
            selectedSites[section[indexPath.section]] = curArray
            //selectedSites.removeValue(forKey: sites[indexPath.section][indexPath.row])
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            //selectedSites.updateValue(section[indexPath.section], forKey: sites[indexPath.section][indexPath.row])
            selectedSites[section[indexPath.section]]!.append(sites[indexPath.section][indexPath.row])
            //var newArray: [String] = selectedSites[section[indexPath.section]].append(sites[indexPath.section][indexPath.row])
            //selectedSites.updateValue(newArray, forKey: section[indexPath.section])
        }
        print(selectedSites)
        print(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
