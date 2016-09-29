//
//  PageTitleView.swift
//  DYTV
//
//  Created by coderLL on 16/9/28.
//  Copyright © 2016年 coderLL. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class {
    func pageTitltView(titleView: PageTitleView, selectedIndex index : Int)
}

// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    
    // MARK:- 定义属性
    private var currentIndex : Int = 0
    var titles:[String]
    weak var delegate : PageTitleViewDelegate?
    
    // MARK:- 懒加载属性
    private lazy var  titleLabels: [UILabel] = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orangeColor()
        return scrollLine
    }()

    // MARK:- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles;
        
        super.init(frame: frame);
        
        // 设置UI界面
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK:- 设置UI界面
extension PageTitleView {
    
    private func setupUI() {
        
        // 1.添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 2.添加titles对应的Label
        setupTitleLabels()
        
        // 3.设置底线和滚动的滑块
        setupBottomLineAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        // 0.确定lable的一些frame值
        let labelW : CGFloat = frame.width/CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0

        for (index, title) in titles.enumerate() {
            // 1.创建UILabel
            let label = UILabel()
            
            // 2.设置Label的属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFontOfSize(16.0)
            label.textColor = UIColor.orangeColor()
            label.textAlignment = .Center
            
            // 3.设置Label的frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4.将label添加到scrollView上和titleLabels数组中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 5.给Lable添加手势
            label.userInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomLineAndScrollLine() {
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2.添加滚动的滑块
        // 2.1 获取第一个Label
        guard let firstLabel = titleLabels.first else { return}
        firstLabel.textColor = UIColor.orangeColor()
        // 2.2 设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

// MARK:- 监听Label的点击
extension PageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        // 1.获取当前Label
        guard let currentLabel = tapGes.view as? UILabel else  { return }
        
        // 2.获取之前的Label
        let oldLabel = titleLabels[currentIndex]
        
        // 3.切换文字的颜色
        currentLabel.textColor = UIColor.orangeColor()
        oldLabel.textColor = UIColor.darkGrayColor()
        
        // 4.保存更新Label的下标值
        currentIndex = currentLabel.tag
        
        // 5.滚动条位置发生改变
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        
        // 6.动画
        UIView.animateWithDuration(0.15) { 
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 7.通知代理
        delegate?.pageTitltView(self, selectedIndex: currentIndex)
    }
}

// MARK:- 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int)  {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.处理颜色的渐变(复杂)
        
        // 3.1 取出变化的范围(元组类型)
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2变化sourceLabel
        sourceLabel.textColor = UIColor(red: (kSelectColor.0 - colorDelta.0 * progress)/255.0, green: (kSelectColor.1 - colorDelta.1 * progress)/255.0, blue: (kSelectColor.2 - colorDelta.2 * progress)/255.0, alpha: 1.0)
        
        // 3.2变化targetLabel
        targetLabel.textColor = UIColor(red: (kNormalColor.0 + colorDelta.0 * progress)/255.0, green: (kNormalColor.1 + colorDelta.1 * progress)/255.0, blue: (kNormalColor.2 + colorDelta.2 * progress)/255.0, alpha: 1.0)
        
        // 3.记录最新的index
        currentIndex = targetIndex
    }
}