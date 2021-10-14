//
//  routeHandlers.swift
//  MySwiftServer
//
//  Created by uwei on 13/01/2017.
//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import MongoDB

let mongoURL = "mongodb://localhost:27017"

public func signupRoutes() -> Routes {
    return addURLRoutes()
}

func addURLRoutes() -> Routes {
    var routes = Routes()
    routes.add(method: .get, uri: "/", handler: helloHandler)
    routes.add(method: .get, uri: "/mongo", handler: queryFullDBHandler)
    routes.add(method: .post, uri: "/add", handler: addHandler)
    return routes
}

func helloHandler(request: HTTPRequest, _ response: HTTPResponse) {
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Hello</title><body>Hello World</body></html>")
    response.completed()
}

func queryFullDBHandler(request: HTTPRequest, _ response: HTTPResponse) {
    
    // 创建连接
    let client = try! MongoClient(uri: mongoURL)
    
    // 连接到具体的数据库，假设有个数据库名字叫 uweidb
    let db = client.getDatabase(name: "uweidb")
    
    // 定义集合
    guard let collection = db.getCollection(name: "uweidb") else {
        return
    }
    
    // 在关闭连接时注意关闭顺序与启动顺序相反
    defer {
        collection.close()
        db.close()
        client.close()
    }
    
    // 执行查询
    let fnd = collection.find(query: BSON())
    
    // 初始化一个空数组用于存放结果记录集
    var arr = [String]()
    
    // "fnd" 游标是一个 MongoCursor 类型，用于遍历结果
    for x in fnd! {
        arr.append(x.asString)
    }
    
    // 返回一个格式化的 JSON 数组。
    let returning = "{\"data\":[\(arr.joined(separator: ","))]}"
    
    // 返回 JSON 字符串
    response.appendBody(string: returning)
    response.completed()
}

func addHandler(request: HTTPRequest, _ response: HTTPResponse) {
    // 创建连接
    let client = try! MongoClient(uri: mongoURL)
    
    // 连接到具体的数据库，假设有个数据库名字叫 uweidb
    let db = client.getDatabase(name: "uweidb")
    
    // 定义集合
    guard let collection = db.getCollection(name: "uweidb") else {
        return
    }
    
    // 定义BSOM对象，从请求的body部分取JSON对象
    let bson = try! BSON(json: request.postBodyString!)
    
    // 在关闭连接时注意关闭顺序与启动顺序相反
    defer {
        bson.close()
        collection.close()
        db.close()
        client.close()
    }
    
    collection.save(document: bson)
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: request.postBodyString!)
    response.completed()
}
