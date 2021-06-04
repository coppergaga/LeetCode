//
// Created by CopperGaga on 2021/6/4.
//

import Foundation
class Solution34 {
    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        let left = binarySearch(nums, target, lower: true)
        let right = binarySearch(nums, target, lower: false) - 1
        if (left <= right) && (left >= 0) && (right < nums.count) && (nums[left] == target) && (nums[right] == target) {
            return [left, right]
        }
        return [-1, -1]
    }

    private func binarySearch(_ nums: [Int], _ target: Int, lower: Bool) -> Int {
        var left = 0
        var right = nums.count - 1
        var mid: Int
        var ret = nums.count
        while left <= right {
            mid = (left + right) / 2
            if (nums[mid] > target) || (lower && (nums[mid] >= target)) {
                right = mid - 1
                ret = mid
            } else {
                left = mid + 1
            }
        }
        return ret
    }
}