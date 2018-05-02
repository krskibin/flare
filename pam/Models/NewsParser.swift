import Foundation
import Alamofire
import Kanna

class NewsParser {
    var pageUrl: String
    
    init(pageUrl: String) {
        self.pageUrl = pageUrl
        self.scrapPage()
    }

    func scrapPage() {
        Alamofire.request(pageUrl).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
                self.parseHTML(html: html)
            }
        }
    }

    func parseHTML(html: String) {
        // swiftlint:disable identifier_name
        if let doc = try? HTML(html: html, encoding: .utf8) {
            print(doc.body?.innerHTML ?? "")
            for show in doc.css("td[id^='Text']") {
                
                var showString = show.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                
                let regex = try? NSRegularExpression(pattern: "*",
                                                     options: [.caseInsensitive])
                
                // swiftlint:disable legacy_constructor
                if regex?.firstMatch(in: showString, options: [],
                                     range: NSMakeRange(0, showString.count)) != nil {
                    print(show)
                    
                    // swiftlint:disable force_cast
                    showString += show as! String
                    print("\(showString)\n")
                }
            }
        }
    }
}
