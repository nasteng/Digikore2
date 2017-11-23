//
//  Unit.swift
//  Digikore
//
//  Created by nasteng on 2017/07/30.
//
//

import Foundation
import UIKit

struct Status {
    var hitPoint: (max: Int, present: Int)
    var strength: Int
    var defence: Int
    var agility: Int
    
    init(hp: Int , str: Int, def: Int, agi: Int) {
        hitPoint.max = hp
        hitPoint.present = hp
        strength = str
        defence = def
        agility = agi
    }
}

enum UnitType: String {
    case divine
    case enemy
}

enum Element: String {
    case ray
    case darkness
    case flame
    case ice
    case thunder
    case wind
    
    var image: UIImage? {
        switch self {
        case .ray:
            return UIImage(named: "r_shine")
        case .darkness:
            return UIImage(named: "r_dark")
        case .flame:
            return UIImage(named: "r_fire")
        case .ice:
            return UIImage(named: "r_ice")
        case .thunder:
            return UIImage(named: "r_thunder")
        case .wind:
            return UIImage(named: "r_leaf")
        }
    }
}

class Unit {
    let name: String
    let displayName: String
    var status: Status
    let unitType: UnitType
    let element: Element
    let batleImage: UIImage?
    let multiple: Int?
    
    init(name: String, status: Status, unitType: UnitType, element: Element, multiple: Int? = nil) {
        self.multiple = multiple
        self.status = status
        self.unitType = unitType
        self.element = element
        if let image = UIImage(named: name) {
            self.batleImage = image
        } else {
            self.batleImage = nil
        }
        
        if let multiple = multiple {
            self.displayName = name + "\(multiple)"
        } else {
            self.displayName = name
        }
        
        self.name = name
    }
}

extension Unit: BattleLogicProtocol {
    func attack(to target: Unit, result: ((BattleLog) -> Void)) {
        var dead: UnitType? = nil
        var damage: Int {
            if status.strength - target.status.defence > 0 {
                return status.strength - target.status.defence
            }
            return 0
        }
        
        if target.status.hitPoint.present > 0 {
            target.damaged(amount: damage){ isDead in
                if isDead {
                    dead = UnitType(rawValue: target.unitType.rawValue)
                }
            }
            
            let log = BattleLog(attacker: displayName, attackersHP: status.hitPoint.present,target: target.displayName, damage: damage, lastHPOfTarget: target.status.hitPoint.present, dead: dead)
            
            result(log)
        }
    }
    
    func damaged(amount: Int, isDead:(Bool) -> Void) {
        status.hitPoint.present -= amount
        if status.hitPoint.present <= 0 {
            status.hitPoint.present = 0
            isDead(true)
        } else {
            isDead(false)
        }
    }
}
