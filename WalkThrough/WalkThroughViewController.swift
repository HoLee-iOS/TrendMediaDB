//
//  WalkViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/16.
//

import UIKit

import TrendMediaFramework

class WalkThroughViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    var walkthroughPageViewController: WalkThroughPageViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkThroughPageViewController {
            walkthroughPageViewController = pageViewController
        }
    }
    
    
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: ViewController.reuseIdentifier) as? ViewController else { return }
        let nav = UINavigationController(rootViewController: vc)
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
        UserDefaults.standard.set(true, forKey: "First")
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if let index = walkthroughPageViewController?.currentPageIndex {
            switch index {
            case 0...3:
                walkthroughPageViewController?.nextPage()
            case 4:
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = sb.instantiateViewController(withIdentifier: ViewController.reuseIdentifier) as? ViewController else { return }
                
                let nav = UINavigationController(rootViewController: vc)
                sceneDelegate?.window?.rootViewController = nav
                sceneDelegate?.window?.makeKeyAndVisible()
                UserDefaults.standard.set(true, forKey: "First")
            default:
                break
            }
            pageControl.currentPage = index + 1
        }
    }
    
    
}
