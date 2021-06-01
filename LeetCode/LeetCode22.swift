//
// Created by GaoXudong on 2021/6/1.
//

import Foundation
class Solution22 {
    var ret = [String]()
    let bracket = "()"

    func generateParenthesis(_ n: Int) -> [String] {
        gen("", left: n, right: n)
        return ret
    }

    func gen(_ curStr: String, left: Int, right: Int) {
        if left == 0 && right == 0 {
            ret.append(curStr)
            return
        }

        if left < 0 || right < 0 {
            return
        }

        if left > right {
            return
        }

        if left > 0 {
            gen(curStr + "(", left: left - 1, right: right)
        }

        if right > 0 {
            gen(curStr + ")", left: left, right: right - 1)
        }
    }
}