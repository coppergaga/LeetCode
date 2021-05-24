//
//  LeetCode6.swift
//  SwiftConsole
//
//  Created by GaoXudong on 2021/4/2.
//

import Foundation

class Solution6 {
    func convert(_ s: String, _ numRows: Int) -> String {
        guard s.count > numRows && numRows > 1 else {
            return s
        }
        
        var rows = [String](repeating: "", count: min(s.count, numRows))
        
        var idx = 0
        var ifChangeDirect = false
        
        for char in s {
            rows[idx].append(char)
            
            if idx >= numRows - 1 || idx <= 0 {
                ifChangeDirect.toggle()
            }
            
            idx += ifChangeDirect ? 1 : -1
        }
        
        var res = ""
        
        for str in rows {
            res += str
        }
        
        return res
    }
    
    func reverse(_ x: Int) -> Int {
        let max = 214748364
        let min = -214748364
        
        var xValue = x
        
        var res = 0
        
        while xValue != 0 {
            let temp = xValue % 10
            
            if res > max || (res == max && temp > 7){
                return 0
            }
            
            if res < min || (res == min && temp < -8) {
                return 0
            }
            
            res = res * 10 + temp
            xValue /= 10
        }
        return res
    }
}

class Stack<Element> {
    var data = [Element?]()
    func pop() -> Element? {
        let ret = data.last ?? nil
        data = Array(data.dropLast())
        return ret
    }
    
    func push(_ e: Element?) {
        data.append(e)
    }
    
    func isEmpty() -> Bool { return data.filter{ $0 != nil }.count <= 0 }
}

class TreeNode {
    var left: TreeNode?
    var right: TreeNode?
    
    private var _value: Int = 0
    var value: Int {
        get {
            return _value
        }
        set {
            _value = newValue
        }
    }
    
    init(_ value: Int, left: TreeNode? = nil, right: TreeNode? = nil) {
        self.value = value
        self.left = left
        self.right = right
    }
}

func visit(_ node: TreeNode) {
    print(node.value)
}

//先序遍历
func preOrderRecursion(node: TreeNode?) {
    guard let node = node else {
        return
    }
    visit(node)
    preOrderRecursion(node: node.left)
    preOrderRecursion(node: node.right)
}

func preOrderTraversal(node: TreeNode?) {
    guard let node = node else {
        return
    }
    let stack = Stack<TreeNode>()
    stack.push(node)
    while !stack.isEmpty() {
        if let currentNode = stack.pop() {
            visit(currentNode)
            stack.push(currentNode.right)
            stack.push(currentNode.left)
        }
    }
}

//中序遍历
func inOrderRecursion(node: TreeNode?) {
    guard let node = node else {
        return
    }
    inOrderRecursion(node: node.left)
    visit(node)
    inOrderRecursion(node: node.right)
}

func inOrderTraversal(node: TreeNode?) {
    guard let node = node else {
        return
    }
    let stack = Stack<TreeNode>()
    var currentNode: TreeNode? = node
    
    while currentNode != nil || !stack.isEmpty() {
        while currentNode != nil {
            stack.push(currentNode)
            currentNode = currentNode?.left
        }
        currentNode = stack.pop()
        visit(currentNode!)
        currentNode = currentNode?.right
    }
}

//后序遍历
func postOrderRecursion(node: TreeNode?) {
    guard let node = node else {
        return
    }
    postOrderRecursion(node: node.left)
    postOrderRecursion(node: node.right)
    visit(node)
}

func postOrderTraversal(node: TreeNode?) {
    let stack = Stack<TreeNode>()
    var ret = [TreeNode]()
    stack.push(node)
    while !stack.isEmpty() {
        if let curNode = stack.pop() {
            ret.append(curNode)
            stack.push(curNode.left)
            stack.push(curNode.right)
        }
    }
    for node in ret.reversed() {
        print(node.value)
    }
}
