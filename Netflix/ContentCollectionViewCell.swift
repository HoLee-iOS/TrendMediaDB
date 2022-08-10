//
//  ContentCollectionViewCell.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/09.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    func setupUI() {
        
        cardView.backgroundColor = .clear
//        cardView.posterImageView.backgroundColor = .systemRed
        cardView.posterImageView.layer.cornerRadius = 10
        
    }
    
}
