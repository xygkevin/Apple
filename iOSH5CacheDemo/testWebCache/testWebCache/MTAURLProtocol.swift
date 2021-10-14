//
//  MTAURLProtocol.swift
//  MTAManager
//
//  Created by uwei on 07/03/2017.
//  Copyright © 2017 Tencent. All rights reserved.
//

import UIKit

fileprivate let filterHeaderKey = "X-Cache"
fileprivate let filterProtocolKey = "protocolKey"

fileprivate let CacheDataKey = "data"
fileprivate let CacheRequestKey = "request"
fileprivate let CacheResponseKey = "response"

extension URLRequest {
    func copyRequest() -> NSMutableURLRequest {
        let mutableRequest = NSMutableURLRequest(url: self.url!, cachePolicy: self.cachePolicy, timeoutInterval: self.timeoutInterval)
        mutableRequest.allHTTPHeaderFields = self.allHTTPHeaderFields
        if self.httpBodyStream != nil {
            mutableRequest.httpBodyStream = self.httpBodyStream
        } else {
            mutableRequest.httpBody = self.httpBody
        }
        mutableRequest.httpMethod = self.httpMethod!
        
        return mutableRequest
    }
}


extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

class MTAH5CacheData: NSObject,NSCoding {
    var data:Data?
    var redirectRequest:URLRequest?
    var reponse:URLResponse?
    
    override init() {
        super.init()
        self.data = nil
        self.redirectRequest = nil
        self.reponse = nil
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.data, forKey: CacheDataKey)
        aCoder.encode(self.redirectRequest, forKey: CacheRequestKey)
        aCoder.encode(self.reponse, forKey: CacheResponseKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.data = aDecoder.decodeObject(forKey: CacheDataKey) as? Data
        self.redirectRequest = aDecoder.decodeObject(forKey: CacheRequestKey) as? URLRequest
        self.reponse = aDecoder.decodeObject(forKey: CacheResponseKey) as? URLResponse
    }
}

@objc class MTAURLProtocol: URLProtocol, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    fileprivate var responseData:NSMutableData?
    fileprivate var connection:NSURLConnection?
    fileprivate var response:URLResponse?
    fileprivate var session:URLSession?
    
    
    override class func canInit(with:URLRequest) -> Bool { // 是否拦截请求，再做处理
        var isBlockRequest = false
        if with.url != nil {
            if let host = with.url!.host, host.contains("cnn.com") {
                if with.value(forHTTPHeaderField: filterHeaderKey) == nil {
                    isBlockRequest = true
                }
            }
            
            
        }
        return isBlockRequest
    }
    
    override class func canonicalRequest(for: URLRequest) ->URLRequest {
        let request = NSMutableURLRequest(url: `for`.url!, cachePolicy: `for`.cachePolicy, timeoutInterval: `for`.timeoutInterval)
        request.setValue("", forHTTPHeaderField: filterHeaderKey)
        return request as URLRequest
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(a, to: b)
    }
    
    override func startLoading() {
        if useCache() {
            let cacheData = NSKeyedUnarchiver.unarchiveObject(withFile: self.cachePathForRequest(request: self.request)) as? MTAH5CacheData
            if cacheData != nil {
                let data = cacheData?.data
                let redirectRequest = cacheData?.redirectRequest
                let response = cacheData?.reponse
                if redirectRequest != nil {
                    self.client?.urlProtocol(self, wasRedirectedTo: redirectRequest!, redirectResponse: response!)
                } else {
                    self.client?.urlProtocol(self, didReceive: response!, cacheStoragePolicy: .notAllowed)
                    self.client?.urlProtocol(self, didLoad: data ?? NSMutableData() as Data)
                    self.client?.urlProtocolDidFinishLoading(self)
                }
            } else {
                self.client?.urlProtocol(self, didFailWithError: (NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo: nil)))
            }

            
        } else {
            
            self.connection = NSURLConnection(request: self.request , delegate: self)
//            self.connection?.start()
        }
    }
    
    override func stopLoading() {
        self.connection?.cancel()
//        if self.connection != nil {
//            self.connection?.cancel()
//            self.connection = nil
//        }
//        
//        self.session = nil
    }
    
    
    func connection(_ connection: NSURLConnection, willSend request: URLRequest, redirectResponse response: URLResponse?) -> URLRequest? {
        if response != nil {
//            let redirectRequest = request.copyRequest()
            var redirectRequest = request
            redirectRequest.setValue(nil, forHTTPHeaderField: filterHeaderKey)
            let path = self.cachePathForRequest(request: self.request)
            let cache = MTAH5CacheData()
            cache.reponse = response
            cache.data    = self.responseData as Data?
            cache.redirectRequest = redirectRequest as URLRequest
            
            NSKeyedArchiver.archiveRootObject(cache, toFile: path)
            self.client?.urlProtocol(self, wasRedirectedTo: redirectRequest as URLRequest, redirectResponse: response!)
           return redirectRequest as URLRequest
        } else {
            return request
        }
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        self.client?.urlProtocol(self, didFailWithError: error)
        self.connection = nil
        self.responseData = nil
        self.response     = nil
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.response = response
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.client?.urlProtocol(self, didLoad: data)
//        self.appendData(data: data)
        if self.responseData == nil {
            self.responseData = NSMutableData()
        }
        self.responseData?.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        self.client?.urlProtocolDidFinishLoading(self)
        
        let cachePath = self.cachePathForRequest(request: self.request)
        let cacheData = MTAH5CacheData()
        cacheData.data = self.responseData as Data?
        cacheData.reponse = self.response
        NSKeyedArchiver.archiveRootObject(cacheData, toFile: cachePath)
        
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                print(cookie.expiresDate ?? "expires date is null")
            }
        }
        
        self.connection = nil
        self.responseData = nil
        self.response     = nil
        
    }
    
    func cachePathForRequest(request:URLRequest) -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
        let fileName = request.url?.absoluteString.sha1()
        return (cachePath! as NSString).appendingPathComponent(fileName!)
    }
    
    func useCache() -> Bool {
        var status = false
        if TTKReachability(hostName: self.request.url!.host!).currentReachabilityStatus() != TTKNetworkStatus.notReachable {
            status = false
        } else {
            status = true
        }
        
        return status
    }
    
    func appendData(data:Data) -> Void {
        if self.responseData == nil {
            self.responseData = (data as! NSMutableData).mutableCopy() as? NSMutableData
        } else {
            self.responseData?.append(data)
        }
    }
    
}
