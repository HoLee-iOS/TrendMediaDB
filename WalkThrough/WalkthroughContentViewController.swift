//
//  WalkthroughContentViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/16.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var introLabel: UILabel!
    
    var image: UIImage?
    var label: String?
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        introLabel.text = label
        introLabel.numberOfLines = 0
        introLabel.font = .systemFont(ofSize: 20, weight: .bold)
        imageView.alpha = 0
        introLabel.alpha = 0
        
        UIView.animate(withDuration: 5) {
            self.imageView.alpha = 1
            self.introLabel.alpha = 1
        } completion: { _ in
            
        }

        
    }
    

    

}
