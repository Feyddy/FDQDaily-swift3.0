//
//  FDTopCustomView.swift
//  FDQDaily
//
//  Created by t3 on 2017/3/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

import UIKit



protocol FDTopCustomViewDelegate {
    func didClickButtonAtIndex(index: NSInteger)
}

let KTopViewHeight: CGFloat = 64.0

class FDTopCustomView: UIView {

    //MARK: --- 内部属性
    fileprivate var sliderView: UIView?
    fileprivate var buttonArray: [UIButton]?
    fileprivate var width: CGFloat?
    fileprivate var selectedButton: UIButton?
    fileprivate var bottomScrollView: UIScrollView?
    
    //MARK: --- 外部属性
    /**底部线条颜色*/
    var sliderBackgroundColor: UIColor?
    
    /**未选中的标题颜色*/
    var normalTitleColor: UIColor?
    
    /**选中的标题颜色*/
    var selectedTitleColor: UIColor?
    
    /**标题数组*/
    var titleArray: NSArray? {
        didSet {
            setSubViewsWithArray()
        }
    }
    
    /**控制器数组*/
    var vcArray: NSMutableArray? {
        didSet {
            setBottomScrolleView()
        }
    }
    
    var fatherVc: UIViewController? {
        didSet {
            bottomScrollView?.removeFromSuperview()
            setBottomScrolleView()
        }
    }
    
    var delegate: FDTopCustomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buttonArray = [UIButton]()
        
        //设置一些默认颜色
        normalTitleColor = UIColor.gray
        selectedTitleColor = UIColor.black
        sliderBackgroundColor = UIColor.orange
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setSubViewsWithArray() {
        
        //创建两个按钮进行点击
        for (index, element) in (titleArray?.enumerated())! {
            let title = element as! String
            let btn = UIButton ()
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(normalTitleColor, for: .normal)
            btn.setTitleColor(selectedTitleColor, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            
            if index == 0 {
                btn.isSelected = true
                selectedButton = btn
            }
            
            btn.addTarget(self, action: #selector(FDTopCustomView.subButtonSelected(_ :)), for: .touchUpInside)
            
            btn.tag = index
            addSubview(btn)
            buttonArray?.append(btn)
        }
        
        //创建一条滑动的线，点击按钮滑动到指定按钮下面
        sliderView = UIView()
        sliderView?.backgroundColor = sliderBackgroundColor
        addSubview(sliderView!)
    }
    
    fileprivate func setBottomScrolleView() {
        bottomScrollView = UIScrollView()
        bottomScrollView?.frame = CGRect(x: 0, y: KTopViewHeight, width: SCREEN_WIDTH, height: SCREENH_HEIGHT - KTopViewHeight)
        addSubview(bottomScrollView!)
        
        for (i , element) in (vcArray?.enumerated())! {
            let vcFrame = CGRect(x: CGFloat(i) * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: (bottomScrollView?.frame.size.height)!)
            let vc = element as! UIViewController
            vc.view.frame = vcFrame
            fatherVc?.addChildViewController(vc)
            bottomScrollView?.addSubview(vc.view)
            
        }
        
        bottomScrollView?.contentSize = CGSize(width: CGFloat((vcArray?.count)!) * SCREEN_WIDTH, height: 0)
        
        bottomScrollView?.isPagingEnabled = true
        bottomScrollView?.showsHorizontalScrollIndicator = false
        bottomScrollView?.showsVerticalScrollIndicator = false
        bottomScrollView?.isDirectionalLockEnabled = true
        bottomScrollView?.bounces = false
        bottomScrollView?.delegate = self
    }
    
    
    internal override func layoutSubviews() {
         super.layoutSubviews()
        
        width = SCREEN_WIDTH / CGFloat((buttonArray?.count)! * 3)
        
        let buttonWidth = SCREEN_WIDTH / CGFloat((buttonArray?.count)!)
        
        for (i , element) in (buttonArray?.enumerated())! {
            element.frame = CGRect(x: CGFloat(i) * buttonWidth, y: 15, width: buttonWidth, height: KTopViewHeight - 15)
            
        }
        
        let buttonx = (buttonArray?[0].center.x)! - width! / 2
        sliderView?.frame = CGRect(x: buttonx, y: KTopViewHeight - 3, width: width! - 4, height: 3)
        
    }
    
    
    @objc fileprivate func subButtonSelected(_ sender: UIButton) {
        //改变上一个选中按钮的选中状态
        selectedButton?.isSelected = false
        
        //改变当前按钮的选中状态
        sender.isSelected = true
        
        //重新赋值选中的按钮
        selectedButton = sender
    
        //代理事件
        delegate?.didClickButtonAtIndex(index: sender.tag)
        
        bottomScrollView?.setContentOffset(CGPoint(x: CGFloat(sender.tag) * SCREEN_WIDTH, y: 0), animated: true)
        
    }
    
    fileprivate func sliderViewAnimationWithButtonIndex(index: NSInteger) {
        UIView.animate(withDuration: 0.25) { 
            let btnX = (self.buttonArray?[index].center.x)! - (self.width! / 2)
            var tempFrame = self.sliderView?.frame
            tempFrame?.origin.x = btnX
            self.sliderView?.frame = tempFrame!
        }
    }
    
}

extension FDTopCustomView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / SCREEN_WIDTH
        sliderViewAnimationWithButtonIndex(index: NSInteger(index))
        
        let btn = buttonArray?[NSInteger(index)]
        
        //改变上一个选中按钮的选中状态
        selectedButton?.isSelected = false
        
        //改变当前按钮的选中状态
        btn?.isSelected = true
        
        //重新赋值选中的按钮
        selectedButton = btn
        
        btn?.setTitleColor(normalTitleColor, for: .normal)
        btn?.setTitleColor(selectedTitleColor, for: .selected)
        
    }
    
}
