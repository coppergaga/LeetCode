//
// Created by CopperGaga on 2021/6/2.
//

import Foundation
class Solution31 {
    func nextPermutation(_ nums: inout [Int]) {
        var i = nums.count - 1
        while (i > 0) {
            if nums[i] > nums[i - 1] {
                var j = nums.count - 1
                while (j >= i) {
                    if (nums[i - 1] < nums[j]) {
                        nums.swapAt(i - 1, j)
                        var sub = nums[i..<nums.count]
                        sub.sort()
                        nums.replaceSubrange(i..<nums.count, with: sub)
                        return
                    }
                    j -= 1
                }
            }

            i -= 1
        }
        nums.sort()
    }
}