//
//  Dictionary+Extension.swift
//  Gondol
//
//  Created by JYG on 2021/11/13.
//

import Foundation

extension Dictionary {
    subscript(i:Int) -> (key: Key, value: Value) {
        get {
            return self[index(startIndex, offsetBy: i)]
        }
    }
}
