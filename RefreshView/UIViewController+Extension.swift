//
//  UIViewController+Extension.swift
//  RefreshView
//
//  Created by bruce on 2019/12/18.
//  Copyright © 2019 ZouLiangming. All rights reserved.
//

import UIKit

public extension UIViewController {
    var isShowLoadingView: Bool {
        get {
            let loadingView = self.view.viewWithTag(kRefreshLoadingTag) as? CustomRefreshLoadingView
            if loadingView != nil {
                return true
            }
            return false
        }
        set(newValue) {
            if newValue {
                let loadingView = CustomRefreshLoadingView()
                loadingView.tag = kRefreshLoadingControllerTag
                self.view.addSubview(loadingView)
                loadingView.startAnimation()
            } else {
                let loadingView = self.view.viewWithTag(kRefreshLoadingControllerTag) as? CustomRefreshLoadingView
                loadingView?.stopAnimation()
                loadingView?.removeFromSuperview()
            }
        }
    }
}
