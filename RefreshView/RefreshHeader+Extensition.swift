//
//  RefreshHeader+Extensition.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 16/1/25.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

public extension UIScrollView {
    var refreshHeader: CustomRefreshHeaderView? {
        get {
            return self.viewWithTag(kRefreshHeaderTag) as? CustomRefreshHeaderView
        }
        set(newValue) {
            if newValue != self.refreshHeader {
                self.willChangeValue(forKey: "header")
                newValue!.tag = kRefreshHeaderTag
                self.refreshHeader?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.bringSubview(toFront: newValue!)
                objc_setAssociatedObject(self, kRefreshHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValue(forKey: "header")
            }
        }
    }

    var refreshFooter: CustomRefreshFooterView? {
        get {
            let view = self.viewWithTag(kRefreshFooterTag) as? CustomRefreshFooterView
            return view
        }
        set(newValue) {
            if newValue != self.refreshFooter {
                self.willChangeValue(forKey: "footer")
                newValue!.tag = kRefreshFooterTag
                self.refreshFooter?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.bringSubview(toFront: newValue!)
                objc_setAssociatedObject(self, kRefreshFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValue(forKey: "footer")
            }
        }
    }

    var isShowLoadingView: Bool {
        get {
            let loadingView = self.viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
            if let _ = loadingView {
                return true
            }
            return false
        }
        set(newValue) {
            if newValue {
                self.willChangeValue(forKey: "loading")
                let loadingView = CustomRefreshLoadingView()
                loadingView.tag = kRefreshLoadingTag

                self.addSubview(loadingView)
                loadingView.startAnimation()
                objc_setAssociatedObject(self, kRefreshLoadingKey, newValue, .OBJC_ASSOCIATION_RETAIN)
                self.didChangeValue(forKey: "loading")
            } else {
                let loadingView = self.viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
                loadingView?.stopAnimation()
                loadingView?.removeFromSuperview()
            }
        }
    }

    var loadingView: CustomRefreshLoadingView? {
        get {
            return self.viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
        }
    }
}
