//
//  LeetCode10.swift
//  SwiftConsole
//
//  Created by GaoXudong on 2021/5/18.
//

import Foundation
class Solution10 {
    // s [a~z]
    // p [a~z . *]
    func isMatch(_ s: String, _ p: String) -> Bool {
        if p.contains(".*") {
            return true
        }

        var lastChr = Character("0")
        let dotChr = Character(".")
        let asteriskChr = Character("*")

        for pChr in p {
            var compChr = pChr
            if (pChr == asteriskChr) {
                compChr = lastChr
            }

            for sChr in s {
                if (compChr == dotChr) {
                    break
                }
                if (sChr == compChr) {

                }

            }

            lastChr = pChr
        }


        return true
    }
}
