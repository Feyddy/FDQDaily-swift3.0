//
//  FDPostModel.swift
//  FDQDaily
//
//  Created by t3 on 2017/3/6.
//  Copyright © 2017年 feyddy. All rights reserved.
//

import UIKit
import MJExtension

class FDPostModel: NSObject {

    /**新闻标题*/
    var title:String?
    /**副标题*/
    var subhead:String?
    /**出版时间*/
    var publish_time:String?
    /**配图*/
    var image:String?
    /**评论数*/
    var comment_count:String?
    /**点赞数*/
    var praise_count:String?
    /**新闻文章链接（html格式）*/
    var appview:String?
    
    var category:FDCategoryModel?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["subhead":"description"]
    }
}
