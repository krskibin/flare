//
//  OnboardingTableViewController.swift
//  pam
//
//  Created by Tobiasz Dobrowolski on 07.06.2018.
//  Copyright © 2018 Krystian Skibiński. All rights reserved.
//

import UIKit

class OnboardingTableViewController: UITableViewController {
    
    let section = ["General", "Mobile", "Programming", "Video Games", "Design"]
    let sites = [["The Verge", "Engadget", "Wired", "9to5Mac"],
                 ["Android Police", "TechRadar"],
                 ["Developer Tech", "Lifehacker"],
                 ["IGN", "Eurogamer", "GameSpot"],
                 ["Brand New", "Co.Design"]]

    var selectedSites = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func endOnboarding(_ sender: Any) {
        UserDefaults.standard.set(selectedSites, forKey: "selectedSitesArray")
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
            selectedSites = selectedSites.filter{$0 != sites[indexPath.section][indexPath.row]}
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            selectedSites.append(sites[indexPath.section][indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
