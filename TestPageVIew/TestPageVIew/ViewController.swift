//
//  ViewController.swift
//  TestPageVIew
//
//  Created by coderLL on 16/9/29.
//  Copyright © 2016年 coderLL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:- 懒加载属性
    private lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: 20, width: UIScreen.mainScreen().bounds.width, height: 40)
        let titles = ["推荐", "游戏", "娱乐", "体育"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
        }()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        // 1.确定内容的frame
        let contentFrame = CGRect(x: 0, y: 60, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height)
        
        // 2.确定所有的子控制器
        var childVcs = [UIViewController]()
        for _ in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1.0)
            childVcs.append(vc)
        }
        let pageContentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        pageContentView.delegate = self
        
        return pageContentView
        }()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置UI界面
        setupUI()
    }
    
}

// MARK:- 设置UI界面
extension ViewController {
    
    private func setupUI() {
        
        // 1.添加TitltView
        view.addSubview(pageTitleView)
        
        // 2.添加contentView
        view.addSubview(pageContentView)
        
    }
    
}

// MARK:- 遵守PageTitleViewDelegate协议
extension ViewController : PageTitleViewDelegate {
    func pageTitltView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index)
    }
}

// MARK:- 遵守PageContentViewDelegate
extension ViewController : PageContentViewDelegate {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}


