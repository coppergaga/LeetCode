//
// Created by GaoXudong on 2021/5/24.
//

import Foundation
class Solution20 {
    func isValid(_ s: String) -> Bool {
        var stack = [Character]()
        for item in s {
            if let top = stack.last {
                if checkIfMatch(top, item) {
                    stack.removeLast()
                } else {
                    stack.append(item)
                }
            } else {
                stack.append(item)
            }
        }
        return stack.count <= 0
    }
    
    private func checkIfMatch(_ left: Character, _ right: Character) -> Bool {
        var ret = false
        switch right {
            case Character(")"):
                if left == Character("(") {
                    ret = true
                }
            case Character("}"):
                if left == Character("{") {
                    ret = true
                }
            case Character("]"):
                if left == Character("[") {
                    ret = true
                }
            default:
                ret = false
        }
        return ret
    }
}