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
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}

//public ListNode removeNthFromEnd(ListNode head, int n) {
//    ListNode dummy = new ListNode(0, head);
//    ListNode first = head;
//    ListNode second = dummy;
//    for (int i = 0; i < n; ++i) {
//        first = first.next;
//    }
//    while (first != null) {
//        first = first.next;
//        second = second.next;
//    }
//    second.next = second.next.next;
//    ListNode ans = dummy.next;
//    return ans;
//}

class Solution19 {
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        let temp = ListNode(0, head)
        var left: ListNode? = temp
        var right = head

        for _ in 0..<n {
            right = right?.next
        }

        while (right != nil) {
            left = left?.next
            right = right?.next
        }

        left?.next = left?.next?.next

        return temp.next
    }

    func generateLinkedList(_ src: [Int]) -> ListNode?{
        var head: ListNode?
        var last: ListNode?

        for val in src {
            var cur = ListNode(val)
            if let lastT = last {
                lastT.next = cur
                last = cur
            } else {
                head = cur
                last = cur
            }
        }
        return head
    }
}