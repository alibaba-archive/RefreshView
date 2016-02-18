RefreshView
=========

This library provides three loading method in UITableView or UICollectionView: pull to refresh,  scroll to bottom to refresh and loading.

It provides:

- An `CustomRefreshLoadingView`  loading when view first loaded.
- An `CustomRefreshHeaderView` pulling to refresh.
- An `CustomRefreshFooterView`   scrolling to bottom to refresh.

demo gif(https://github.com/teambition/RefreshView/blob/master/demo.gif)

How To Use
----------
### Using CustomRefreshLoadingView
Show loading view
```swift
tableView.showLoadingView = true
collectionView?.showLoadingView = true
```
Hide loading view:
```swift
tableView.showLoadingView = false
collectionView?.showLoadingView = false
```
### Using CustomRefreshHeaderView
Support RefreshHeaderView:
```swift
// UICollectionView
self.collectionView.refreshHeader = CustomRefreshHeaderView.headerWithRefreshingBlock({
// do something 
// end refresh header view
self.collectionView.refreshHeader?.endRefreshing()
})

// UITableView
self.tableView.refreshHeader = CustomRefreshHeaderView.headerWithRefreshingBlock({
// do something 
// end refresh header view
self.collectionView?.refreshHeader.endRefreshing()
})
```
### Using CustomRefreshFooterView
Support RefreshFooterView:
```swift
// UICollectionView
self.collectionView.refreshFooter = CustomRefreshFooterView.footerWithLoadingText("Loading More Data", startLoading: {
// do something 
// end refresh and determine whether to display 
self.collectionView.refreshFooter.showLoadingView = yourCondition 
})

// UITableView
self.tableView.refreshFooter = CustomRefreshFooterView.footerWithLoadingText("Loading More Data", startLoading: {
// do something 
// end refresh and determine whether to display 
self.tableView.refreshFooter.showLoadingView = yourCondition 
})
```

Installation
------------

There are two ways to use RefreshView in your project:
- using carthage
- copying all the files into your project


### Installation with Carthage (iOS 8+)

[Carthage](https://github.com/Carthage/Carthage) is a lightweight dependency manager for Swift and Objective-C. It leverages CocoaTouch modules and is less invasive than CocoaPods.

To install with carthage, follow the instruction on [Carthage](https://github.com/Carthage/Carthage)

#### Cartfile
```
github "teambition/RefreshView"
```

### Installation by cloning the repository

In order to gain access to all the files from the repository, you should clone it.
```
git clone --recursive https://github.com/teambition/RefreshView.git
```

## Licenses

All source code is licensed under the [MIT License](https://github.com/teambition/RefreshView/blob/master/LICENSE).
