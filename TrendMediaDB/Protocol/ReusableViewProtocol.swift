//
//  ReusableViewProtocol.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/03.
//

import UIKit

protocol ReusableViewProtocol {
    static var resuseIdentifier: String { get }
}

extension UITableViewCell: ReusableViewProtocol {
    
    static var resuseIdentifier: String {
        return String(describing: self)
    }
    
}

