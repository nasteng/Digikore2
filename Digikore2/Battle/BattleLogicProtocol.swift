//
//  BattleLogicProtocol.swift
//  Digikore
//
//  Created by nasteng on 2017/09/23.
//
//

import Foundation

protocol BattleLogicProtocol {
    func attack(to target: Unit, result: ((BattleLog) -> Void))
    func damaged(amount: Int, isDead:(Bool) -> Void)
}
