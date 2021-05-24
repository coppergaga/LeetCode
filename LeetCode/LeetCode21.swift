//
// Created by GaoXudong on 2021/5/24.
//

import Foundation
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init() { self.val = 0; self.next = nil; }
 *     public init(_ val: Int) { self.val = val; self.next = nil; }
 *     public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
 * }
 */

class Solution {
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var dummy = ListNode(0)

        var pre: ListNode? = dummy
        var left = l1
        var right = l2
        
        while ((left != nil) && (right != nil)) {
            if left!.val > right!.val {
                pre?.next = right
                right = right?.next
            } else {
                pre?.next = left
                left = left?.next
            }

            pre = pre?.next
        }

        pre?.next = left == nil ? right : left
        return dummy.next
    }
}