//
//  FDHomeViewController.swift
//  FDQDaily
//
//  Created by t3 on 2017/3/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

import UIKit
import MJRefresh
import MBProgressHUD

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
    
    fileprivate var responseModel:FDResponsModel?
    fileprivate lazy var feedsArray:[AnyObject] = [AnyObject]()
    fileprivate lazy var bannersArray:[AnyObject] = [AnyObject]()
    fileprivate lazy var imageArray:[AnyObject] = [AnyObject]()
    
    //刷新控件
    fileprivate var refreshHeader: MJRefreshNormalHeader?
    fileprivate var refreshFooter: MJRefreshAutoNormalFooter?
    fileprivate var sunrefreshView: YALSunnyRefreshControl = YALSunnyRefreshControl()
    fileprivate var cell:HomeNewsCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData()
        
        contentArray = NSMutableArray()
        view.backgroundColor = UIColor.white
        
        //设置下拉刷新
        sunrefreshView.addTarget(self, action: #selector(FDHomeViewController.refreshData), for: .valueChanged)
        sunrefreshView.attach(to: self.tableView)

        //设置上拉加载
        refreshFooter = MJRefreshAutoNormalFooter.init(refreshingBlock: { 
            self.loadData()
        })
        refreshFooter?.setTitle("加载更多...", for: .refreshing)
        refreshFooter?.setTitle("没有更多内容", for: .noMoreData)
        tableView.mj_footer = refreshFooter
    }
    
    
    @objc fileprivate func refreshData() {
        //清空数据
        contentArray?.removeAllObjects()
        FDHomeNewsDataManager.shareInstance.requestHomeNewDataWithLatKey(lastKey: "0") { (responseObject, error) in
            
            if error != nil {
                MBProgressHUD.promptHudWithShowHUDAddedTo(self.view, message: "加载失败")
                return
            }else
            {
                if let tempDict = responseObject {
                    //处理数据
                    self.responseModel = FDResponsModel.mj_object(withKeyValues: tempDict)
                    self.last_key = self.responseModel?.last_key
                    self.has_more = self.responseModel?.has_more
                    
                    //获取feeds数组
                    self.feedsArray = FDFeedsModel.mj_objectArray(withKeyValuesArray: tempDict["feeds"]) as [AnyObject]
                    self.contentArray?.addObjects(from: self.feedsArray)
                    
                    //获取banner数组
                    self.bannersArray = FDBannerModel.mj_objectArray(withKeyValuesArray: tempDict["banners"]) as [AnyObject]
                    
                    self.sunrefreshView.endRefreshing()
                    
                    self.tableView.reloadData()
                    
                }
            }
            
            
        }
    }
    
    
    fileprivate func loadData() {
    

        if has_more == "1" {
        
            FDHomeNewsDataManager.shareInstance.requestHomeNewDataWithLatKey(lastKey: last_key!, finished: { (responseObject, error) in
                //处理数据
                self.responseModel = FDResponsModel.mj_object(withKeyValues: responseObject)
                self.last_key = self.responseModel?.last_key
                self.has_more = self.responseModel?.has_more
                
                //获取feeds数组
                self.feedsArray = FDFeedsModel.mj_objectArray(withKeyValuesArray: responseObject?["feeds"]) as [AnyObject]
                for feedModel in self.feedsArray {
                    let model = feedModel as! FDFeedsModel
                    self.contentArray?.insert(model, at: (self.contentArray?.count)!)
                }
                self.refreshFooter?.endRefreshing()
                self.tableView.reloadData()
                
            })
        
        } else if has_more == "0" {
            refreshFooter?.state = MJRefreshState.noMoreData
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contentArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rid = "homeCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: rid) as? HomeNewsCell
        
        if cell == nil {
            cell = HomeNewsCell.init(style: .default, reuseIdentifier: rid)
        }
        
        if (contentArray?.count)! > 0 {
            let feedModel = contentArray?[indexPath.row]
            cell?.feedModel = feedModel as! FDFeedsModel?
        }
        
        self.cell = cell
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cell?.cellType == "0" {
            return 360
        } else if cell?.cellType == "2" {
            return 360
        } else {
            return 130
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedModel = contentArray?[indexPath.row] as! FDFeedsModel
        let appView = feedModel.post?.appview
//        let readVc = r
    }
    
    
    

}
