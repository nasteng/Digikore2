//
//  DKUnitStatusView.swift
//  Digikore2
//
//  Created by Tomo_N on 2017/11/24.
//  Copyright © 2017年 Tomo_N. All rights reserved.
//

import UIKit

class DKUnitStatusView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    // ステータス表示用ラベル
    @IBOutlet private weak var strengthLabel: UILabel!
    @IBOutlet private weak var defenceLabel: UILabel!
    @IBOutlet private weak var agilityLabel: UILabel!
    @IBOutlet private weak var magicLabel: UILabel!
    @IBOutlet private weak var luckyLabel: UILabel!
    @IBOutlet private weak var secretLabel: UILabel!
    @IBOutlet private weak var HPlabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet var unitStatusLabelCollection: [UILabel]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DKUnitStatusView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    func setup(from unit: Unit) {
        updateStatusLabel(from: unit)
        for label in unitStatusLabelCollection {
            label.font = UIFont.systemFont(ofSize: label.frame.size.height)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.frame.size.height)
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func updateStatusLabel(from unit: Unit) {
        nameLabel.text = unit.name
        levelLabel.text = String(21)
        classLabel.text = String("天使")
        
        HPlabel.text = "\(unit.status.hitPoint.present)/\(unit.status.hitPoint.present)"
        strengthLabel.text = String(unit.status.strength)
        defenceLabel.text = String(unit.status.defence)
        agilityLabel.text = String(unit.status.agility)
        magicLabel.text = String(100)
        luckyLabel.text = String(100)
        secretLabel.text = String(100)
    }
}
