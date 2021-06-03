//
// Created by GaoXudong on 2021/6/3.
//

import Foundation
class Solution33 {
    func search(_ nums: [Int], _ target: Int) -> Int {
        if nums.count == 0 {
            return -1
        } else if (nums.count == 1) {
            return nums[0] == target ? 0 : -1
        }

        var start = 0
        var end = nums.count - 1

        while start <= end {
            var mid = (end + start) / 2
            if target == nums[mid] {
                return mid
            }

            if nums[start] <= nums[mid] {
                if (target >= nums[start]) && (target < nums[mid]) {
                    end = mid - 1
                } else {
                    start = mid + 1
                }
            } else {
                if (target > nums[mid]) && (target <= nums[end]) {
                    start = mid + 1
                } else {
                    end = mid - 1
                }
            }
        }
        return -1
    }
}