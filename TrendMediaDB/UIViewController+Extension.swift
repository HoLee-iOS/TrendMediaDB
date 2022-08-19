//
//  UIViewController+Extension.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/18.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case present
        case push
    }
    
    //TMDB
    func transitionViewController<T: UIViewController>(storyboard: String, viewController vc: T.Type, transitionStyle: TransitionStyle, completion: ((T)->())?) {
        
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        guard let viewController = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else { return }
        completion?(viewController)
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
}
