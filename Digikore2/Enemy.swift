//
//  Enemy.swift
//  Digikore
//
//  Created by nasteng on 2017/09/28.
//

import Foundation

final class Enemy: Unit {
    init(name: String, status: Status, element: Element, multiple: Int? = nil) {
        super.init(name: name, status: status, type: .enemy, element: element, multiple: multiple)
    }
}
