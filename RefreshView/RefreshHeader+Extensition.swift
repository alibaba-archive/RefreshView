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
                newValue!.tag = kRefreshHeaderTag
                self.refreshHeader?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.bringSubview(toFront: newValue!)
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
                newValue!.tag = kRefreshFooterTag
                self.refreshFooter?.removeFromSuperview()
                self.insertSubview(newValue!, at: 0)
                self.bringSubview(toFront: newValue!)
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
                let loadingView = CustomRefreshLoadingView()
                loadingView.tag = kRefreshLoadingTag

                self.addSubview(loadingView)
                loadingView.startAnimation()
            } else {
                let loadingView = self.viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
                loadingView?.stopAnimation()
                loadingView?.removeFromSuperview()
            }
        }
    }

    var loadingView: CustomRefreshLoadingView? {
        return self.viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
    }
}
