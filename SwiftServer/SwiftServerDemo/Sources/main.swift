import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


struct Filter404: HTTPResponseFilter {
    func filterBody(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        callback(.continue)
    }
    
    func filterHeaders(response: HTTPResponse, callback: (HTTPResponseFilterResult) -> ()) {
        if case .notFound = response.status {
            response.bodyBytes.removeAll()
            response.setBody(string: "\(response.request.path) is not exist --Notice by uwei.")
            response.setHeader(.contentLength, value: "\(response.bodyBytes.count)")
            callback(.done)
        } else {
            callback(.continue)
        }
    }
}


let routes = signupRoutes()

let server = HTTPServer()
server.addRoutes(routes)
server.serverPort = 8181

do {
    try server
        .setResponseFilters([(Filter404(), .high)])
        .start()
} catch PerfectError.networkError(let err, let msg) {
    print("Error Message: \(err) \(msg)")
}



