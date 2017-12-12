//
//  BattleDetailLogViewController.swift
//  Digikore
//
//  Created by nasteng on 2017/09/23.
//
//

import UIKit

class BattleDetailLogViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    fileprivate var battleLogs: [BattleLog]!
    fileprivate var loggedUnits: [Unit]!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(battleLogs: [BattleLog], loggedUnits: [Unit]!, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.battleLogs = battleLogs
        self.loggedUnits = loggedUnits
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscapeRight]
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 40.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func parse(_ log: BattleLog) -> String {
        var parsedText: String = ""
        if log.damage > 0 {
            parsedText = ("\(log.attacker)の攻撃! \(log.target)に\(log.damage)のダメージ!")
            
            if let dead = log.dead {
                switch dead {
                case .divine:
                    parsedText  += "\n" + log.target + "は死んでしまった"
                case .enemy:
                    parsedText += "\n" + log.target + "を浄化した!"
                }
            }
            
            return  parsedText
        }
        
        parsedText = ("\(log.attacker)の攻撃! ミス!")
        return parsedText
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BattleDetailLogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let animationVC = BattleAnimationViewController(units: loggedUnits, battleLogs: battleLogs, nibName: "BattleAnimationViewController", bundle: nil)
        self.navigationController?.pushViewController(animationVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BattleDetailLogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return battleLogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = parse(battleLogs[indexPath.row])
        print("parse(battleLogs[indexPath.row]) -> \(parse(battleLogs[indexPath.row]))")
        return cell
    }
}



