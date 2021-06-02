//
// Created by CopperGaga on 2021/5/23.
//

import Foundation

class Solution17 {
    func letterCombinations(_ digits: String) -> [String] {
        guard digits.count > 0 else {
            return []
        }

        var ret = [String]()
//        DFS(nums: digits, ans: &ret)
        BFS(digits: digits, ans: ret)
        return ret
    }

    let letterMap = [
        "2":["a", "b", "c"],
        "3":["d", "e", "f"],
        "4":["g", "h", "i"],
        "5":["j", "k", "l"],
        "6":["m", "n", "o"],
        "7":["p", "q", "r", "s"],
        "8":["t", "u", "v"],
        "9":["w", "x", "y", "z"]
    ]

    func DFS(nums: String, ans: inout [String]) {
        guard nums.count > 0 else {
            ans.append("")
            return
        }

        let cur = nums[nums.startIndex]

        var partialAns = [String]()
        DFS(nums: String(nums[nums.index(nums.startIndex, offsetBy: 1)...]), ans: &partialAns)

        for item in letterMap[String(cur)]! {
            for parStr in partialAns {
                ans.append(item + parStr)
            }
        }
    }

    func BFS(digits: String, ans: [String]) -> [String] {
        guard digits.count > 0 else {
            return []
        }

        let cur = digits[digits.startIndex]
        let curSet = letterMap[String(cur)]!

        var temp = [String]()
        if ans.count == 0 {
            for _ in curSet {
                temp.append("")
            }
        } else {
            temp = ans
        }

        var queue = [String]()

        for lastAns in temp {
            for item in curSet {
                queue.append(lastAns + item)
            }
        }

        return BFS(digits: String(digits[digits.index(digits.startIndex, offsetBy: 1)...]), ans: queue)
    }
}