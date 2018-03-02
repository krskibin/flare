import UIKit

class FirstViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func isNumberEven(number: Int) -> Bool {
        if  !(number % 2 == 0) {
            return false
        }
        return true
    }

}
