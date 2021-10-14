//
//  main.swift
//  CompositePatterDemo
//
//  Created by forwardto9 on 16/3/21.
//  Copyright © 2016年 forwardto9. All rights reserved.
//

import Foundation

print("Hello, World!")

// MARK: Swift 如何实现Hashable协议的
class TreeNode {
    var parentNode:TreeNode?
    var name:String?
    
    internal var hashValue: Int { return 100 }
    
//    private var children:Set<TreeNode> = []
    
    init(name:String) {
        self.name = name
    }
    
    func add(node:TreeNode) -> Void {
        
    }
    
    func remove(node:TreeNode) -> Void {
    }
    
//    func ==(lhs: TreeNode, rhs: TreeNode) -> Bool
}

class Tree {
    var root:TreeNode?
    init(name:String) {
        root = TreeNode(name: name);
    }
}

// 使得用户对单个对象和组合对象的使用具有一致性

let tree = Tree(name: "tree")
let nodeA = TreeNode(name: "A")
let nodeB = TreeNode(name: "B")
nodeA.add(nodeB)
tree.root?.add(nodeA)

