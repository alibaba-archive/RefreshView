//
//  CustomRefreshView.swift
//  RefreshView
//
//  Created by bruce on 16/5/12.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

open class CustomRefreshView: UIView {

    var pan: UIPanGestureRecognizer?
    var scrollView: UIScrollView?
    var pullingPercent: CGFloat = 0
    var start: (() -> ())?
    var insetTDelta: CGFloat = 0
    var scrollViewOriginalInset: UIEdgeInsets?
    var originInset: UIEdgeInsets?

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
}
