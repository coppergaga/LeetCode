//
//  LeetCode11.swift
//  SwiftConsole
//
//  Created by GaoXudong on 2021/5/20.
//

import Foundation
class Solution11 {
    func maxArea(_ height: [Int]) -> Int {
        var area = 0
        var left = 0
        var right = height.count - 1
        while left < right {
//            let space = right - left
//            if (height[left] < height[right]) {
//                let temp = height[left] * space
//                if temp > area {
//                    area = temp
//                }
//                left += 1
//            } else {
//                let temp = height[right] * space
//                if temp > area {
//                    area = temp
//                }
//                right -= 1
//            }
            let temp = min(height[left], height[right]) * (right - left)
            area = max(temp, area)
            if height[left] < height[right] {
                left += 1
            } else {
                right -= 1
            }
        }
        
        return area;
    }
}
