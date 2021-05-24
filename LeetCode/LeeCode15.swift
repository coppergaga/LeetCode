//
// Created by GaoXudong on 2021/5/21.
//

import Foundation
class Solution15 {
    func threeSum(_ nums: [Int]) -> [[Int]] {
        guard nums.count > 2 else { return [] }

        var ret = [[Int]]()

        let sortedNums = nums.sorted()
        let length = sortedNums.count

        var aIdx = 0
        var lastAvalue = sortedNums[aIdx]
        while aIdx < length - 2 {
            if aIdx > 0 {
                if lastAvalue == sortedNums[aIdx] {
                    aIdx += 1
                    continue
                }
            }

            var bIdx = aIdx + 1
            var cIdx = length - 1

            var lastBvalue = Int.max
            var lastCvalue = Int.max
            while bIdx < cIdx {
                if sortedNums[aIdx] + sortedNums[bIdx] + sortedNums[cIdx] == 0 {
                    ret.append([sortedNums[aIdx], sortedNums[bIdx], sortedNums[cIdx]])
                    bIdx += 1
                    cIdx -= 1
                    while (bIdx < cIdx) && (sortedNums[bIdx] == sortedNums[bIdx - 1]) { bIdx += 1 }
                    while (bIdx < cIdx) && (sortedNums[cIdx] == sortedNums[cIdx + 1]) { cIdx -= 1 }
                } else if sortedNums[aIdx] + sortedNums[bIdx] + sortedNums[cIdx] < 0 {
                    bIdx += 1
                } else {
                    cIdx -= 1
                }

            }
            lastAvalue = sortedNums[aIdx]
            aIdx += 1
        }
        return ret
    }
}