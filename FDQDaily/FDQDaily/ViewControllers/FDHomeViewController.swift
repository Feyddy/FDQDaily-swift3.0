//
//  FDHomeViewController.swift
//  FDQDaily
//
//  Created by t3 on 2017/3/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

import UIKit

let  SCREEN_WIDTH  = UIScreen.main.bounds.size.width//屏幕宽度
let  SCREENH_HEIGHT = UIScreen.main.bounds.size.height//屏幕高度

class FDHomeViewController: UITableViewController {
    
    
    
    //MARK: --- 属性
    /**model 数组*/
    fileprivate var contentArray: NSMutableArray?
    
    /** 是否还有未加载的文章 0：没有 1：有*/
    fileprivate var has_more:String?
    /** 拼接 到url 中的last_key*/
    fileprivate var last_key:String?
    // tableView滑动y的偏移量
    fileprivate var contentOffsetY:CGFloat?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       loadData()
    }
    
    fileprivate func loadData() {
    

        FDHomeNewsDataManager.shareInstance.requestHomeNewDataWithLatKey(lastKey: "0") { (responseObject, error) in
            print(responseObject)
        }
    }

}
