//
//  ViewController.swift
//  NRQE
//
//  Created by Zel Marko on 4/27/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var pageControl: UIPageControl!
	
	var pageContainer: UIPageViewController!
	var pages = [ReusableViewController]()
	
	var currentIndex: Int?
	var pendingIndex: Int?
	var availablePages = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for i in 1...3 {
			let page = storyboard!.instantiateViewControllerWithIdentifier("ReusableViewController") as! ReusableViewController
			page.index = i
			pages.append(page)
		}
		
		pageContainer = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
		pageContainer.delegate = self
		pageContainer.dataSource = self
		pageContainer.setViewControllers([pages[0]], direction: .Forward, animated: false, completion: nil)
		
		view.addSubview(pageContainer.view)
		
		pageControl.currentPage = 0
		pageControl.numberOfPages = pages.count
		view.bringSubviewToFront(pageControl)
	}
	
	func resetPages(index: Int) {
		availablePages = index
		pageContainer.reloadInputViews()
	}
	
	func nextPage(index: Int) {
		pageContainer.setViewControllers([pages[index]], direction: .Forward, animated: true, completion: nil)
		pageContainer.reloadInputViews()
		pageControl.currentPage = index
	}
}

extension ViewController: UIPageViewControllerDataSource {
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
		let currentIndex = pages.indexOf(viewController as! ReusableViewController)!
		if currentIndex == pages.count - 1 {
			return nil
		}
		let nextIndex = abs((currentIndex + 1) % pages.count)
		if nextIndex > availablePages {
			return nil
		}
		return pages[nextIndex]
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {

		let currentIndex = pages.indexOf(viewController as! ReusableViewController)!
		if currentIndex == 0 {
			return nil
		}
		let previousIndex = abs((currentIndex - 1) % pages.count)
		return pages[previousIndex]
	}
}

extension ViewController: UIPageViewControllerDelegate {
	
	func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
		
		pendingIndex = pages.indexOf(pendingViewControllers.first! as! ReusableViewController)
	}
	
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		
		if completed {
			currentIndex = pendingIndex
			if let index = currentIndex {
				pageControl.currentPage = index
			}
		}
	}
}
