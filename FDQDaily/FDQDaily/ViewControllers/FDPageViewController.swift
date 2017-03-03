//
//  FDPageViewController.swift
//  FDQDaily
//
//  Created by t3 on 2017/3/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

import UIKit

class FDPageViewController: UIPageViewController {
    
    
    //MARK: --- 内部属性
    fileprivate var pageView: FDTopCustomView?
    fileprivate var suspensionView: FDSuspensionView?
    fileprivate var menuView: FDMenuView?
    
    fileprivate lazy var subViewControllers: NSMutableArray = {
       
        var array = NSMutableArray()
        var vc1 = FDHomeViewController()
        var vc2 = FDHomeLABSViewController()
        array.add(vc1)
        array.add(vc2)
        return array
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        let array = ["NEWS","LABS"]
        pageView = FDTopCustomView()
        pageView?.titleArray = array as NSArray?
        pageView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREENH_HEIGHT)
        pageView?.vcArray = subViewControllers
        pageView?.fatherVc = self
        view.addSubview(pageView!)
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        let window = UIApplication.shared.keyWindow
        window!.addSubview(suspensionView!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suspensionView?.removeFromSuperview()
    }
    
    
    func setupUI()  {
        suspensionView = FDSuspensionView()
        suspensionView?.frame = CGRect(x: 10, y: SCREENH_HEIGHT - 70, width: 54, height: 54)
        suspensionView?.delegate  = self
        suspensionView?.style = .qDaily
        
        menuView = FDMenuView()
        menuView?.cellBlock = {(methodName:String) -> Void
            in
            self.suspensionView?.style = .close
            let method = NSSelectorFromString(methodName)
            self.perform(method)
            self.menuView?.removeFromSuperview()
        }
        menuView?.popupNewsClassificationViewBlock = {()->Void in
            self.suspensionView?.style = .homeBack
            self.changgeSuspensionViewOffsetX(-SCREEN_WIDTH - 100)
            
        }
        menuView?.hideNewsClassificationViewBlock = {()-> Void in
            self.menuView?.hideNewsClassificationViewAnimation()
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.changgeSuspensionViewOffsetX(15)
            }, completion: { (_) -> Void in
                UIView.animate(withDuration: 0.15, animations: { () -> Void in
                    self.changgeSuspensionViewOffsetX(5)
                }, completion: { (_) -> Void in
                    UIView.animate(withDuration: 0.1, animations: { () -> Void in
                        self.changgeSuspensionViewOffsetX(10)
                    })
                })
            })
            
        }
        menuView?.frame = view.bounds
    }

    // 改变悬浮按钮的x值
    fileprivate func changgeSuspensionViewOffsetX(_ offsetX: CGFloat) {
        var tempFrame = self.suspensionView?.frame
        tempFrame?.origin.x = offsetX
        self.suspensionView?.frame = tempFrame!
    }
    
    
    func aboutUs() {
    
        suspensionView?.buttonStyleReSet(style: .close)
        print("\(#function)")
    }
    
    func newsClassification() {
        suspensionView?.buttonStyleReSet(style: .close)
        print("\(#function)")
        
    }
    
    func paogramaCenter() {
        suspensionView?.buttonStyleReSet(style: .close)
        print("\(#function)")
        
    }
    
    func curiosityResearch() {
        suspensionView?.buttonStyleReSet(style: .close)
        print("\(#function)")
        
    }
    
    func myMessage() {
        suspensionView?.buttonStyleReSet(style: .close)
        print("\(#function)")
        
    }
    
    func userCenter() {

       suspensionView?.buttonStyleReSet(style: .close)
        print("\(#function)")
        
    }
    
    func homePage() {
        suspensionView?.buttonStyleReSet(style: .close)
        print("\(#function)")
        
    }
    

}

extension FDPageViewController: FDSuspensionViewDelegate {
    // MARK: SuspensionViewDelegate
    func popUpMenu() {
        let window = UIApplication.shared.keyWindow
        window!.insertSubview(menuView!, belowSubview:suspensionView!)
        menuView?.popupMunuViewAnimation()
    }
    func closeMenu() {
        menuView?.hideMenuViewAnimation()
    }
    func backToMenuView() {
        suspensionView?.style = .qDaily
        menuView?.hideMenuViewAnimation()
        
    }
}
