//
//  TablePageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/14/24.
//

import UIKit

class TablePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var completeHandler : ((Int) -> ())?
    
    let viewsList : [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Comunity", bundle: nil)
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "postPageVC")
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "scrapPageVC")
        return [vc1, vc2]
    }()
    
    var currentIndex : Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstvc = viewsList.first {
            self.setViewControllers([firstvc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setViewcontrollersFromIndex(index : Int){
        if index < 0 && index >= viewsList.count {
            return
        } else if index == 1 {
            self.setViewControllers([viewsList[index]], direction: .forward, animated: true, completion: nil)
            
        } else {
            self.setViewControllers([viewsList[index]], direction: .reverse, animated: true, completion: nil)
        }
        completeHandler?(currentIndex)
        
    }
    
    // 이동할 때마다 호출
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            completeHandler?(currentIndex)
        }
    }
    
    // 이동 전 호출
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 { return nil }
        return viewsList[previousIndex]
    }
    
    // 이동 후 호출
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewsList.count { return nil }
        return viewsList[nextIndex]
    }
}
