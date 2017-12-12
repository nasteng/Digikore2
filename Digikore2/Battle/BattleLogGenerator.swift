//
//  BattleLogGenerator.swift
//  Digikore
//
//  Created by nasteng on 2017/07/30.
//
//

import Foundation

final class BattleLogGenerator {
    class func generateBattleLog(divines: [Unit], enemies: [Unit]) -> [BattleLog] {
        var battleLogs: [BattleLog] = []
        var continueBattle = true
        
        var divines = divines
        var enemies = enemies
        var allUnit = divines + enemies
        
        // 戦闘開始
        // 1. HPが0以上のユニットだけに絞る
        while continueBattle {
            allUnit = allUnit.filter { $0.status.hitPoint.present > 0 }
            divines = divines.filter { $0.status.hitPoint.present > 0 }
            enemies = enemies.filter { $0.status.hitPoint.present > 0 }
            
            // 2. Agilityで素早さ順に並べる
            allUnit.sort{ $0.status.agility > $1.status.agility }
            
            allUnit.forEach { unit in
                // forEach中にユニットのHPが0になっていることがあるため、改めてHPをチェック
                if unit.status.hitPoint.present > 0 {
                    var target: Unit {
                        var index: Int = 0
                        switch unit.type {
                        case  .divine:
                            index = arc4random_uniform(UInt32(enemies.count)).hashValue
                            return enemies[index]
                        case .enemy:
                            index = arc4random_uniform(UInt32(divines.count)).hashValue
                            return divines[index]
                        }
                    }
                    // 3. 素早さ順でunitが攻撃する
                    unit.attack(to: target) { log in
                        battleLogs.append(log)
                    }
                }
            }
            
            // 4. 生き残ったの敵・味方のユニット数で戦闘続行か判断する
            if divines.filter({ $0.status.hitPoint.present > 0 }).count == 0 {
                continueBattle = false
            } else if enemies.filter({$0.status.hitPoint.present > 0}).count == 0 {
                continueBattle = false
            }
        }

        return battleLogs
    }
}
