//
//  BattleAnimationViewController.swift
//  Digikore
//
//  Created by nasteng on 2017/09/24.
//

import UIKit

enum Formation: Int {
    case alone = 1
    case twin
    case triangle
    case square
    case pentagon
}

class BattleAnimationViewController: UIViewController {
    @IBOutlet weak var battleLogTextView: UIView!
    @IBOutlet weak var battleLogLabel: UILabel!
    @IBOutlet weak var battleStartImageView: UIImageView!
    
    private var battleLogs: [BattleLog]!
    private var index: Int = 0
    private var timer: Timer = Timer()
    private var allUnitViews: [BattleUnitView] = []
    private var divines: [Unit] = []
    private var enemies: [Unit] = []
    private var units: [Unit] = []
    private var drawableHeight: CGFloat = 0.0
    private var viewWidth: CGFloat = 0.0
    private var didBack: Bool = false
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawableHeight = view.bounds.height - battleLogTextView.bounds.height
        viewWidth = view.bounds.width
        self.navigationController?.delegate = self
        setupBattleField()
        startBattle()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        allUnitViews.forEach { (unitView) in
            unitView.layoutSubviews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SoundManager.shared.stopAll()
        index = 0
        timer.invalidate()
        didBack = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SoundManager.shared.stopAll()
        timer.invalidate()
        index = 0
        didBack = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(units: [Unit], battleLogs: [BattleLog], nibName: String?, bundle: Bundle?) {
        self.init(nibName: nibName, bundle: bundle)
        self.units = units
        self.battleLogs = battleLogs
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func divinePosition(formation: Formation) -> [CGRect] {
        let viewWidth = view.bounds.width
        switch formation {
        case .alone:
            return [CGRect(x: view.bounds.size.width / 4, y: view.bounds.size.height / 2 , width: 96, height: 96)]
        case .twin:
            return [
                CGRect(x: 48.0 * 2, y: drawableHeight / 2.0 - 48.0, width: 96.0, height: 96.0),
                CGRect(x: 48.0 * 2, y: drawableHeight - 108.0, width: 96.0, height: 96.0)
            ]
        case .triangle:
            return [
                CGRect(x: viewWidth / 4 + 36.0 , y: drawableHeight / 2 + 12.0, width: 96, height: 96),
                CGRect(x: 48.0 * 2, y: drawableHeight / 2 - 48.0, width: 96, height: 96),
                CGRect(x: 48.0 * 2 , y: drawableHeight - 108.0, width: 96, height: 96)
            ]
        case .square:
            return [
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0)
            ]
        case .pentagon:
            return [
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0)
            ]
        }
    }
    
    func enemyPosition(formation: Formation) -> [CGRect] {
        print("セット時のdrawableHeight -> \(drawableHeight)")

        let viewWidth = view.bounds.width
        switch formation {
        case .alone:
            return [CGRect(x: view.bounds.size.width * 3 / 4, y: view.bounds.size.height / 2 , width: 96, height: 96)]
        case .twin:
            return [
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0)
            ]
        case .triangle:
            return [
                CGRect(x: viewWidth + 96, y: drawableHeight / 2, width: 96, height: 96),
                CGRect(x: viewWidth + 96, y: drawableHeight / 2, width: 96, height: 96),
                CGRect(x: viewWidth + 96, y: drawableHeight / 2 , width: 96, height: 96)
            ]
//            return [
//                CGRect(x: (viewWidth - 96.0 * 4 + 12.0), y: drawableHeight / 2 + 12.0, width: 96, height: 96),
//                CGRect(x: (viewWidth - 96.0 * 2.5), y: drawableHeight / 2 - 48, width: 96, height: 96),
//                CGRect(x: (viewWidth - 96.0 * 2.5), y: drawableHeight - 108, width: 96, height: 96)
//            ]
        case .square:
            return [
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0)
            ]
        case .pentagon:
            return [
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0),
                CGRect(x: 0, y: 0, width: 0, height: 0)
            ]
        }
    }
    
    
    func setupBattleField() {
        index = 0
        divines = units.filter { $0.type == .divine }
        enemies = units.filter { $0.type == .enemy }
        
        let divinePositionRect = divinePosition(formation: Formation(rawValue: divines.count)!)
        for (index, rect) in divinePositionRect.enumerated() {
            let charaView = BattleUnitView(frame: rect)
            view.addSubview(charaView)
            charaView.setup(with: divines[index])
            allUnitViews.append(charaView)
        }
        
        let enemyPositionRect = enemyPosition(formation: Formation(rawValue: enemies.count)!)
        for (index, rect) in enemyPositionRect.enumerated() {
            let charaView = BattleUnitView(frame: rect)
            view.addSubview(charaView)
            charaView.setup(with: enemies[index])
            allUnitViews.append(charaView)
        }
        
        let divineViews = allUnitViews.filter { $0.unitType == .divine}
        let enemyViews = allUnitViews.filter { $0.unitType == .enemy }

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8, animations: {
                enemyViews.forEach { (unitView) in
                    if unitView.name == "シャドウ1" {
                        unitView.frame = CGRect(x: (self.viewWidth - 96.0 * 4 + 12.0), y: self.drawableHeight / 2 + 12.0, width: 96, height: 96)
                    } else if unitView.name == "シャドウ2" {
                        unitView.frame = CGRect(x: (self.viewWidth - 96.0 * 2.5), y: self.drawableHeight / 2 - 48.0, width: 96, height: 96)
                    } else if unitView.name == "シャドウ3" {
                        unitView.frame = CGRect(x: (self.viewWidth - 96.0 * 2.5), y: self.drawableHeight - 108.0, width: 96, height: 96)
                    }
                }
            })
            
            divineViews.forEach({ (unitView) in
                unitView.baseView.fadeIn(duration: 0.6, delay: 0.2, completed: nil)
            })
        }
        
        SoundManager.shared.play(.bgm(.battle))
    }
    
    private func startBattle() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.3, repeats: true, block: { (_) in
            if self.index < self.battleLogs.count, self.didBack == false {
                self.animateView(from: self.battleLogs[self.index])
                self.index += 1
            } else {
                self.stopBattle()
                self.timer.invalidate()
            }
        })
    }
    
    private func stopBattle() {
        SoundManager.shared.stop(.bgm(.battle))
        
        let victory = self.judgeResult(from: self.allUnitViews)
        self.battleLogLabel.text = victory ? "戦いに勝利した" : "全滅..."
        self.allUnitViews.forEach({ (unitView) in
            UIView.animate(withDuration: 1.0, animations: {
                unitView.frame = CGRect(x: self.view.frame.maxX + 96, y: unitView.frame.origin.y, width: 96, height: 96)
            })
        })

        if victory {
            SoundManager.shared.play(.result(Result(rawValue: "win")!))
        } else {
            SoundManager.shared.play(.result(Result(rawValue: "lose")!))
        }
        
    }
    
    private func animateView(from log: BattleLog) {
        let attacker = log.attacker
        let attackerView = detectView(from: attacker)
        let targetView = detectView(from: log.target)
        
        attackerView.flash {
            targetView.updateHPLabel(with: log.lastHPOfTarget)
            
            if log.damage > 0 {
                self.allUnitViews.forEach({ (unitView) in
                    unitView.layoutSubviews()
                })
                
                switch log.attackerType {
                case .divine:
                    SoundManager.shared.play(.effect(.divine))
                case .enemy:
                    SoundManager.shared.play(.effect(.enemy))
                }
            }
            
            if let _ = log.dead {
                self.removeFromField(log.target)
            }
        }
        
        battleLogLabel.text = parse(log)
    }
    
    func removeFromField(_ targetName: String) {
        let deadUnitView = detectView(from: targetName)
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn, animations: {
            deadUnitView.alpha = 0.0
        })
        
        allUnitViews = allUnitViews.filter {$0.name != targetName }
        animator.startAnimation()
    }
    
    func parse(_ log: BattleLog) -> String {
        var parsedText = ""
        if log.damage > 0 {
            parsedText = ("\(log.attacker)の攻撃! \(log.target)に\(log.damage)のダメージ!")
            let targetView = detectView(from: log.target)
            
            targetView.updateHPBar(ratio: log.lastHPOfTarget)
            
            if let dead = log.dead {
                switch dead {
                case .divine:
                    parsedText += "\n" + log.target + "は死んでしまった"
                case .enemy:
                    parsedText += "\n" + log.target + "を浄化した!"
                }
            }
            
            return parsedText
        }
        
        parsedText = ("\(log.attacker)の攻撃! ミス!")
        return parsedText
    }
    
    func judgeResult(from unitViews: [BattleUnitView]) -> Bool {
        guard let lastUnitType = unitViews.first?.unitType else { return false }
        switch lastUnitType {
        case .divine:
            return true
        case .enemy:
            return false
        }
        
    }
    
    func detectView(from unitName: String) -> BattleUnitView {
        var targetView: BattleUnitView {
            var detectedView: BattleUnitView = BattleUnitView()
            allUnitViews.forEach { (unitView) in
                if unitView.name == unitName {
                    detectedView = unitView
                }
            }
            return detectedView
        }
        
        return targetView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BattleAnimationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        SoundManager.shared.stop(.result(.lose))
//        SoundManager.shared.stop(.result(.win))

    }
}
