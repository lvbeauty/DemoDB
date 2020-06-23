//
//  Extension.swift
//  Student_Database
//
//  Created by Tong Yi on 6/11/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
