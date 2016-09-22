//
//  Contant.swift
//  RefreshView
//
//  Created by ZouLiangming on 16/2/18.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import Foundation
import UIKit

let kRefreshHeaderKey = "header"
let kRefreshFooterKey = "footer"
let kRefreshLoadingKey = "loading"
let kRefreshHeaderTag = 999
let kRefreshFooterTag = 9999
let kRefreshLoadingTag = 99999

let kCustomRefreshSlowAnimationTime = 0.4
let kCustomRefreshFastAnimationTime = 0.25
let kCustomRefreshFooterMargin: CGFloat = 10.0
let kCustomRefreshAnimationKey = "custom_rotation"
let kCustomRefreshFooterStatusColor = UIColor(red: 166/255, green: 166/255, blue: 166/255, alpha: 1)

let kPai = CGFloat(M_PI)
let kRefreshKeyPathContentOffset = "contentOffset"
let kRefreshKeyPathContentInset = "contentInset"
let kRefreshKeyPathContentSize = "contentSize"
let kRefreshKeyPathPanState = "state"
let kRefreshHeaderFullCircleOffset: CGFloat = 80.0
let kRefreshHeaderHeight: CGFloat = 54.0
let kRefreshFooterHeight: CGFloat = 44.0
let kRefreshNotCircleHeight: CGFloat = 16
let kRefreshFastAnimationDuration = 0.25

struct TableViewSelectors {
    static let reloadData = #selector(UITableView.reloadData)
    static let endUpdates = #selector(UITableView.endUpdates)
    static let numberOfSections = #selector(UITableViewDataSource.numberOfSections(in:))
}

struct CollectionViewSelectors {
    static let reloadData = #selector(UICollectionView.reloadData)
    static let numberOfSections = #selector(UICollectionViewDataSource.numberOfSections(in:))
}


public enum RefreshState: String {
    case idle = "Idle"
    case pulling = "Pulling"
    case refreshing = "Refreshing"
    case willRefresh = "WillRefresh"
    case noMoreData = "NoMoreData"
}
