import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class ParsedArticle: NSObject, Mappable {
    var content: String?
    
    override init() {
        super.init()
    }
    
    // swiftlint:disable identifier_name
    convenience required init?(map: Map) {
        self.init()
    }
    
    // swiftlint:disable identifier_name
    func mapping(map: Map) {
        content <- map["content"]
    }
}

class Parser {
    var link: String
    var params: [String: String]
    let headers: HTTPHeaders = [
        "x-api-key:": "1tFApQFYCIGZdsNjFITEDf6xBeFBU5vjXf03KuKY"
    ]
    
    init(articleLink link: String, params: [String: String]) {
        self.link = "https://mercury.postlight.com/parser?url=https://trackchanges.postlight.com/building-awesome-cms-f034344d8ed"
        self.params = params
    }
    
    func get() -> Any {
        var content: Any
        if let link = URL(string: link) {
            var urlRequest = URLRequest(url: link)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
            
            var headers: HTTPHeaders
            if let existingHeaders = urlRequest.allHTTPHeaderFields {
                headers = existingHeaders
            } else {
                headers = HTTPHeaders()
            }
            headers["x-api-key"] = "1tFApQFYCIGZdsNjFITEDf6xBeFBU5vjXf03KuKY"
            urlRequest.allHTTPHeaderFields = headers
            
            let request = Alamofire.request(urlRequest).responseObject { (response: DataResponse<ParsedArticle>) in
                print(response.result.value)
            }
            print(request)
        }
        return ""
    }
}
