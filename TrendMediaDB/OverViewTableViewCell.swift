//
//  OverViewTableViewCell.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/04.
//

import UIKit

class OverViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var overViewButton: UIButton!
    
    var overViewButtonTapped : (() -> Void) = {}

    func configureButton() {
        overViewButton.tintColor = .darkGray
        overViewButton.backgroundColor = .clear
        overViewButton.addTarget(self, action: #selector(expandCell), for: .touchUpInside)
    }

    @objc func expandCell() {
        overViewButtonTapped()
    }
    
}
