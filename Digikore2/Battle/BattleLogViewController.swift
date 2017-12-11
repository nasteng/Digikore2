//
//  BattleLogViewController.swift
//  Digikore
//
//  Created by nasteng on 2017/09/23.
//
//

import UIKit

class DungeonLog {
    let title: String
    var battleLogs: [BattleLog] = []
    var loggedUnits: [Unit] = []
    
    init(title: String, survives: [Unit], enemies: [Unit]) {
        self.title = title
        let allUnit = survives + enemies
        allUnit.forEach { (unit) in
            let loggedUnit = Unit(name: unit.name, status: unit.status, type: unit.type, element: unit.element, multiple: unit.multiple)
            loggedUnits.append(loggedUnit)
        }
    }
}

class BattleLogViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var divines: [Character] = []
    private var enemies: [Enemy] = []
    fileprivate var allDungeonLogs: [DungeonLog] = []
    fileprivate var participation: Int = 1

    enum Section: Int {
        case header
        case dungeonLog
        case result
        case count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let valkyrie = Character(name: "ヴァルキリー", status: Status(hp:3500, str: 750, def: 150, agi: 600), element: .ray, charaImage: UIImage(named: "sozai.png")) else {
            return
        }
        
        
        let v2 = Character(name: "ユミル", status: Status(hp: 2000, str: 600, def: 410, agi: 100), element: .ice, charaImage: UIImage(named: "sozai2.png"))!
        
        let v3 = Character(name: "オーディン", status: Status(hp: 5500, str: 800, def: 500, agi: 50), element: .thunder, charaImage: UIImage(named: "sozai2.png"))!
        
        divines.append(valkyrie)
        divines.append(v2)
        divines.append(v3)
        participation = divines.count

        var canContinue = true
        
        for _ in 0..<20 where canContinue {
            createEnemy()
            let dungeonLog = DungeonLog(title: "敵と遭遇した！", survives: divines, enemies: enemies)
            
            let logs = BattleLogGenerator.generateBattleLog(divines: divines, enemies: enemies)
            
            divines = divines.filter { $0.status.hitPoint.present > 0 }
            
            if divines.count <= 0 {
                canContinue = false
            }
            
            dungeonLog.battleLogs = logs

            allDungeonLogs.append(dungeonLog)
        }
    }

    func createEnemies() -> [Enemy] {
        let enemy1 = Enemy(name: "シャドウ", status: Status(hp: 10, str: 450, def: 300, agi: 1000), element: .darkness, multiple: 1)
        
        let enemy2 = Enemy(name: "シャドウ", status: Status(hp: 1050, str: 536, def: 260, agi: 10), element: .darkness, multiple: 2)
        
        let enemy3 = Enemy(name: "シャドウ", status: Status(hp: 650, str: 370, def: 460, agi: 200), element: .darkness, multiple: 3)
        
        return [enemy1, enemy2, enemy3]
//        return [enemy1]
    }
    
    func createEnemy() {
        enemies.removeAll()
        createEnemies().forEach { enemies.append($0) }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscapeRight]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BattleLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .header, .result, .count:
            let cell = tableView.cellForRow(at: indexPath)
            cell?.selectionStyle = .none
            return
        case .dungeonLog:
            let battleLogs = allDungeonLogs[indexPath.row].battleLogs
            let loggedUnits = allDungeonLogs[indexPath.row].loggedUnits
            let identifier = "BattleDetailLogViewController"
            let detailLogVC = BattleDetailLogViewController(battleLogs: battleLogs, loggedUnits: loggedUnits, nibName: identifier, bundle: nil)
            self.navigationController?.pushViewController(detailLogVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BattleLogViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .header:
            return 1
        case .dungeonLog:
            return allDungeonLogs.count
        case .result:
            return 1
        case .count: break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.numberOfLines = 0
        guard indexPath.row <= allDungeonLogs.count else {
            return cell
        }
        
        guard let section = Section(rawValue: indexPath.section) else {
            return cell
        }
        
        let log = allDungeonLogs[indexPath.row]

        switch section {
        case .header:
            cell.textLabel?.text = "戦闘開始！！"
            cell.selectionStyle = .none
        case .dungeonLog:
            let surviveDivines = allDungeonLogs[indexPath.row].loggedUnits.filter { $0.type == UnitType.divine && $0.status.hitPoint.present > 0 }
            cell.textLabel?.text = log.title
            cell.detailTextLabel?.text = "ユニット状況 \(surviveDivines.count)" + "/ \(participation)"
            return cell
        case .result:
            cell.textLabel?.text = divines.count > 0 ? "戦闘に勝利した" : "全滅..."
            cell.selectionStyle = .none
            return cell
        case .count: break
        }
        return cell
    }
}
