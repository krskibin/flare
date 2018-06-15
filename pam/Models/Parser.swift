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
    var articleContent: String? = ""
    
    var link: String
    var params: [String: String]
    let headers: HTTPHeaders = [
        "x-api-key:": "1tFApQFYCIGZdsNjFITEDf6xBeFBU5vjXf03KuKY"
    ]
    
    init(articleLink link: String, params: [String: String]) {
        self.link = link
        self.params = params
    }
    
    func performRequest(params: [String: String], completionHandler: @escaping (String?, Error?) -> Void) {
        var link = "https://mercury.postlight.com/parser?url="
        link += params["url"]!
        
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
            
            let _ = Alamofire.request(urlRequest).responseObject { (response: DataResponse<ParsedArticle>) in
                switch response.result {
                case .failure(let error):
                    completionHandler(nil, error)
                case .success(let responseObject):
                    let result = responseObject.content
                    print(responseObject)
                    completionHandler(result, nil)
                }
            }
        }
    }
}
