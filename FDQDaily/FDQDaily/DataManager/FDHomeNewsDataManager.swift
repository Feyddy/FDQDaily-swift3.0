//
//  FDHomeNewsDataManager.swift
//  FDQDaily
//
//  Created by t3 on 2017/3/3.
//  Copyright © 2017年 feyddy. All rights reserved.
//

import Foundation
import AFNetworking

class FDHomeNewsDataManager: AFHTTPSessionManager {
    
    static let shareInstance: FDHomeNewsDataManager = {
        let baseUrl = URL(string: "http://app3.qdaily.com/app3/")
        let instance = FDHomeNewsDataManager(baseURL: baseUrl, sessionConfiguration: URLSessionConfiguration.default)
        return instance
    }()
    
    
    func requestHomeNewDataWithLatKey(lastKey: String , finished: @escaping (_ responseObject: [String: AnyObject]?, _ error: NSError?) -> ()) {
        let path = "homes/index/\(lastKey).json"
        get(path, parameters: nil, progress: nil, success: { (task, objc) in
            
            guard let arr = (objc as! [String: AnyObject])["response"] as? [String: AnyObject] else {
                finished(nil, NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["message":"没有获取到数据"]))
                return
            }
            finished(arr, nil)
        }) { (task, error) in
            print(error)
            finished(nil, error as NSError?)
        }
    }
    
    func requestHomeLabsDataWithLatKey(lastKey: String , finished: @escaping (_ responseObject: [String: AnyObject]?, _ error: NSError?) -> ()) {
        let path = "papers/index/\(lastKey).json"
        get(path, parameters: nil, progress: nil, success: { (task, objc) in
            
            guard let arr = (objc as! [String: AnyObject])["response"] as? [String: AnyObject] else {
                finished(nil, NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["message":"没有获取到数据"]))
                return
            }
            finished(arr, nil)
        }) { (task, error) in
            print(error)
            finished(nil, error as NSError?)
        }
    }
    
    

}
