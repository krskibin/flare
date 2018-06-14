//
//  ReadingListActivity.swift
//  pam
//
//  Created by Tobiasz Dobrowolski on 14.06.2018.
//  Copyright © 2018 Krystian Skibiński. All rights reserved.
//

import UIKit

class ReadingListActivity: UIActivity {
    
    override var activityTitle: String? {
        return "Add to reading list"
    }
    
    override var activityImage: UIImage? {
        return UIImage(named: "")
    }
    
    override var activityType: UIActivityType {
        return UIActivityType.postToFacebook
    }
    
    override var activityViewController: UIViewController? {
        
        print("user did tap on my activity")
        return nil
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        
    }
}
