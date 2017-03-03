//
//  FDSuspensionView.swift
//  FDQDaily
//
//  Created by t3 on 2017/3/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

import UIKit
import pop




@objc protocol FDSuspensionViewDelegate: NSObjectProtocol{
    @objc optional func popUpMenu()
    @objc optional func closeMenu()
    @objc optional func backHome()
    @objc optional func backToMenuView()
}

class FDSuspensionView: UIView {

    //MARK: --- 内部属性
    fileprivate var suspensionButton: UIButton?
    
    
    //MARK: --- 外部属性
    var delegate: FDSuspensionViewDelegate?
    
    enum buttonStyle : Int {
        case qDaily = 1
        case close
        case navBack
        case homeBack
    }
    
    var style: buttonStyle = .qDaily
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        suspensionButton?.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        var imageName = ""
        if style == .qDaily { // Qlogo样式
            imageName = "c_Qdaily button_54x54_"
        } else if style == .close{ // 关闭样式
            imageName = "c_close button_54x54_"
        } else if style == .navBack{ // 返回样式1
            imageName = "navigation_back_round_normal"
        } else if style == .homeBack{ // 返回样式2
            imageName = "homeBackButton"
        }
        
        suspensionButton?.setImage(UIImage(named: imageName ), for: .normal)
        
    }
    
    
    //MARK: --- 内部方法
    
    //MARK: --- 判断按钮的设置
    func buttonStyleReSet(style: buttonStyle)  {
        //弹出菜单界面
        if style == .qDaily {
            self.suspensionButton?.setImage(UIImage(named: "c_close button_54x54_"), for: .normal)
            //重新设置按钮的tag
            self.style = .close
            
        }
        
        // 关闭菜单界面
        if style == .close {
            self.suspensionButton!.setImage(UIImage(named: "c_Qdaily button_54x54_"), for: UIControlState())
            // 重新设置按钮的tag
            self.style = .qDaily
        }
    }
    
    
    func addButton(frame: CGRect) {
        suspensionButton = UIButton ()
        
        suspensionButton?.addTarget(self, action: #selector(FDSuspensionView.clickSuspentionButton(sender:)), for: .touchUpInside)
        addSubview(suspensionButton!)
    }
    
    @objc fileprivate func clickSuspentionButton(sender: UIButton)  {
        sender.isSelected = !sender.isSelected
        
        if style == .qDaily || style == .close {
            //加判断，防止连击时出现界面逻辑交互混乱
            if 0 == sender.layer.frame.origin.y {
                UIView.animate(withDuration: 0.1, animations: { 
                    self.suspensionButtonAnimationWithoffsetY(80)
                }, completion: { (finished) in
                    self.popAnimationWithOffSet(offSet: -80, beginTime: 0)
                    
                    //弹出菜单界面
                    if self.style == .qDaily {
                        self.suspensionButton?.setImage(UIImage(named: "c_close button_54x54_"), for: .normal)
                        //重新设置按钮的tag
                        self.style = .close
                        
                        //弹出菜单的代理
                        if(self.delegate?.responds(to: #selector(FDSuspensionViewDelegate.popUpMenu)) != nil) {
                            self.delegate?.popUpMenu!()
                        }
                        return
                        
                    }
                    
                    // 关闭菜单界面
                    if self.style == .close {
                        self.suspensionButton!.setImage(UIImage(named: "c_Qdaily button_54x54_"), for: UIControlState())
                        // 重新设置按钮的tag
                        self.style = .qDaily
                        // 关闭菜单代理
                        if (self.delegate?.responds(to: #selector(FDSuspensionViewDelegate.closeMenu)) != nil) {
                            self.delegate?.closeMenu!()
                        }
                        return
                    }
                    
                    
                })
            }
        }
        
        // 返回首页
        if style == .navBack {
            style = .qDaily
            if (self.delegate?.responds(to: #selector(FDSuspensionViewDelegate.backHome)) != nil) {
                self.delegate?.backHome!()
            }
            return
        }
        
        // 返回到MenuView
        if style == .homeBack{
            if (self.delegate?.responds(to: #selector(FDSuspensionViewDelegate.backToMenuView)) != nil) {
                self.delegate?.backToMenuView!()
            }
            return
        }
        
        
        
    }
    
    
   
    
    
    //MARK: --- pop动画
    fileprivate func popAnimationWithOffSet(offSet: CGFloat, beginTime: CGFloat) {
        let popSpring = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        popSpring?.toValue = (self.suspensionButton?.center.y)! + offSet
        popSpring?.beginTime = CACurrentMediaTime() + Double(beginTime)
        popSpring?.springSpeed = 18
        popSpring?.springBounciness = 10
        self.suspensionButton?.pop_add(popSpring, forKey: "positionY")
    }
    
    fileprivate func suspensionButtonAnimationWithoffsetY(_ offsetY: CGFloat) {
        var tempFrame = self.suspensionButton?.layer.frame
        tempFrame?.origin.y += offsetY
        self.suspensionButton?.layer.frame = tempFrame!
    }
    
    
    
    //MARK: --- 外部方法

}
