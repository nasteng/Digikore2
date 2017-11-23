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
    
    func parse(_ logs: BattleLog) -> String {
        var parsedText = ""
        let attacker = logs.attacker
        let target = logs.target
        let damage = logs.damage
        let dead = logs.dead
        
        if damage > 0 {
            parsedText = ("\(attacker)の攻撃! \(target)に\(damage)のダメージ!")
            //            let targetView = detectTargetView(with: target)
            
            //            targetView.battleEffectImageView.animationImages = EffectImageManager.shared.effectImages(.slash)
            //            targetView.battleEffectImageView.animationRepeatCount = 1
            //            targetView.battleEffectImageView.startAnimating()
            
            if let dead = dead {
                switch dead {
                case .divine:
                    parsedText  += "\n" + target + "は死んでしまった"
                case .enemy:
                    parsedText += "\n" + target + "を浄化した!"
                }
            }
        } else {
            parsedText = ("\(attacker)の攻撃! ミス!")
        }
        
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



