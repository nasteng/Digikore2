//
//  BattleLog.swift
//  Digikore
//
//  Created by nasteng on 2017/09/23.
//
//

import Foundation

final class BattleLog {
    let attacker: String
    let attackerType: UnitType
    let target: String
    let dead: UnitType?
    let damage: Int
    let lastHPOfTarget: Int
    
    init(attacker: String, attackerType: UnitType, target: String, damage: Int, lastHPOfTarget: Int, dead: UnitType?) {
        self.attacker = attacker
        self.attackerType = attackerType
        self.target = target
        self.dead = dead
        self.damage = damage
        self.lastHPOfTarget = lastHPOfTarget
    }
}
