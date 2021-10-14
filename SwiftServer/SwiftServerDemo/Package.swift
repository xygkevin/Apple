import PackageDescription
let package = Package(
 name: "SwiftServerDemo",
 targets: [],
 dependencies: [
     .Package(url:"https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
     .Package(url:"https://github.com/PerfectlySoft/Perfect-MongoDB.git", majorVersion: 2, minor: 0)
    ]
)
