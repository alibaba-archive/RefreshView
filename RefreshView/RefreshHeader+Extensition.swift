//
//  RefreshHeader+Extensition.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 16/1/25.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

let RefreshHeaderKey = "header"
let RefreshFooterKey = "footer"
let RefreshHeaderTag = 999
let RefreshFooterTag = 1000

public extension UIScrollView {
    var refreshHeader: CustomRefreshHeaderView? {
        get {
            return self.viewWithTag(RefreshHeaderTag) as? CustomRefreshHeaderView
        }
        set(newValue) {
            if newValue != self.refreshHeader {
                self.willChangeValueForKey("header")
                newValue!.tag = RefreshHeaderTag
                self.refreshHeader?.removeFromSuperview()
                self.insertSubview(newValue!, atIndex: 0)
                objc_setAssociatedObject(self, RefreshHeaderKey,newValue, .OBJC_ASSOCIATION_RETAIN);
                self.didChangeValueForKey("header")
            }
        }
    }
    
    var refreshFooter: CustomRefreshFooterView? {
        get {
            return self.viewWithTag(RefreshFooterTag) as? CustomRefreshFooterView
        }
        set(newValue) {
            if newValue != self.refreshFooter {
                self.willChangeValueForKey("footer")
                newValue!.tag = RefreshFooterTag
                self.refreshFooter?.removeFromSuperview()
                self.insertSubview(newValue!, atIndex: 0)
                objc_setAssociatedObject(self, RefreshHeaderKey,newValue, .OBJC_ASSOCIATION_RETAIN);
                self.didChangeValueForKey("footer")
            }
        }
    }
}
