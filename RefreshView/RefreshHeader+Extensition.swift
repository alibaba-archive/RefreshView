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
            return viewWithTag(kRefreshHeaderTag) as? CustomRefreshHeaderView
        }
        set(newValue) {
            if newValue == nil {
                refreshHeader?.removeFromSuperview()
            } else if newValue != refreshHeader {
                newValue?.tag = kRefreshHeaderTag
                refreshHeader?.removeFromSuperview()
                insertSubview(newValue!, at: 0)
                bringSubview(toFront: newValue!)
            }
        }
    }

    var refreshFooter: CustomRefreshFooterView? {
        get {
            return viewWithTag(kRefreshFooterTag) as? CustomRefreshFooterView
        }
        set(newValue) {
            if newValue == nil {
                refreshFooter?.removeFromSuperview()
            } else if newValue != refreshFooter {
                newValue?.tag = kRefreshFooterTag
                refreshFooter?.removeFromSuperview()
                insertSubview(newValue!, at: 0)
                bringSubview(toFront: newValue!)
            }
        }
    }

    var isShowLoadingView: Bool {
        get {
            let loadingView = viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
            return loadingView != nil
        }
        set(newValue) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                if newValue {
                    let loadingView = CustomRefreshLoadingView()
                    loadingView.tag = kRefreshLoadingTag
                    strongSelf.addSubview(loadingView)
                    loadingView.startAnimation()
                    strongSelf.isScrollEnabled = false
                } else {
                    let loadingView = strongSelf.viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
                    loadingView?.stopAnimation()
                    loadingView?.removeFromSuperview()
                    strongSelf.isScrollEnabled = true
                }
            }
        }
    }

    var loadingView: CustomRefreshLoadingView? {
        return viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
    }
}
