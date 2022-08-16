//
//  WalkThroughViewController.swift
//  TrendMediaDB
//
//  Created by 이현호 on 2022/08/16.
//

import UIKit

class WalkThroughPageViewController: UIPageViewController {
    
    var viewControllerList: [UIViewController] = []
    var pageControl = UIPageControl()
    
    var pageIntro = ["메인화면에서는 영화의 평점과 제목에 대해 볼 수 있습니다.", "상세화면에서는 줄거리와 캐스팅 정보를 볼 수 있습니다.", "메뉴화면에서는 각 영화의 비슷한 콘텐츠들을 확인해 볼 수 있습니다.", "예고편 버튼을 클릭하면 각 영화의 예고편을 유튜브를 통해 감상하실 수 있습니다.", "돋보기 버튼을 클릭하면 지도를 이용해서 주변 영화관 검색이 가능합니다."]
    var pageImages = [UIImage(named: "메인화면")!, UIImage(named: "상세화면")!, UIImage(named: "메뉴화면")!, UIImage(named: "예고편")!, UIImage(named: "지도")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configurePageViewController()
        if let startViewController = contentViewController(at: 0) {
            setViewControllers([startViewController], direction: .forward, animated: true)
        }
    }
    
    
    func contentViewController(at index: Int) -> WalkthroughContentViewController? {
        if index < 0 || index >= pageIntro.count {
            return nil
        }
        let sb = UIStoryboard(name: "WalkThrough", bundle: nil)
        if let pageContentViewController = sb.instantiateViewController(withIdentifier: WalkthroughContentViewController.reuseIdentifier) as? WalkthroughContentViewController {
            
            pageContentViewController.image = pageImages[index]
            pageContentViewController.label = pageIntro[index]
            pageContentViewController.index = index
            return pageContentViewController
        }
        
        return nil
    }
    
    func configurePageViewController() {
        delegate = self
        dataSource = self
        
    }
    
    var currentPageIndex = 0
    func nextPage() {
        currentPageIndex += 1
        if let nextViewController = contentViewController(at: currentPageIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true)
        }
    }
    
    
}

extension WalkThroughPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    
    
}
