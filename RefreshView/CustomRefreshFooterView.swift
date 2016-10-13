//
//  CustomRefreshFooterView.swift
//  RefreshView
//
//  Created by ZouLiangming on 16/1/28.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

open class CustomRefreshFooterView: CustomRefreshView {

    fileprivate var loadingText = LocalizedString(key: "Loading")
    fileprivate var isAutomaticallyRefresh = true
    fileprivate var triggerAutomaticallyRefreshPercent: CGFloat = 0.1

    var state: RefreshState? {
        didSet {
            if state == .refreshing {
                startAnimation()
                executeRefreshingCallback()
            } else if state == .idle {
                if cellsCount() != 0 {
                    circleImageView?.layer.removeAnimation(forKey: kCustomRefreshAnimationKey)
                }
            }
        }
    }

    open var isShowLoadingView = true {
        didSet {
            if oldValue != isShowLoadingView {
                if !isShowLoadingView {
                    showFooterView(false)
                } else {
                    if self.cellsCount() != 0 {
                        showFooterView(true)
                    } else {
                        showFooterView(false)
                    }
                }
            } else {
                showFooterView(isShowLoadingView)
            }
        }
    }

    lazy var logoImageView: UIImageView? = {
        let image = self.getImage(of: "loading_logo")
        let imageView = UIImageView(image: image)
        imageView.isHidden = true
        self.addSubview(imageView)
        return imageView
    }()

    lazy var circleImageView: UIImageView? = {
        let image = self.getImage(of: "loading_circle")
        let imageView = UIImageView(image: image)
        imageView.isHidden = true
        self.addSubview(imageView)
        return imageView
    }()

    lazy var statusLabel: UILabel? = {
        let statusLabel = UILabel()
        statusLabel.font = statusLabel.font.withSize(15)
        statusLabel.text = self.loadingText
        statusLabel.textColor = kCustomRefreshFooterStatusColor
        statusLabel.isHidden = true
        self.addSubview(statusLabel)
        return statusLabel
    }()

    func getImage(of name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        let bundle = Bundle(for: classForCoder)
        let image = UIImage(named: name, in: bundle, compatibleWith: traitCollection)
        guard let newImage = image else {
            return UIImage()
        }
        return newImage
    }

    fileprivate func cellsCount() -> Int {
        var count = 0
        if let tableView = self.scrollView as? UITableView {
            let sections = tableView.numberOfSections
            for section in 0..<sections {
                count += tableView.numberOfRows(inSection: section)
            }
        } else if let collectionView = self.scrollView as? UICollectionView {
            let sections = collectionView.numberOfSections
            for section in 0..<sections {
                count += collectionView.numberOfItems(inSection: section)
            }
        }
        return count
    }

    fileprivate func showFooterView(_ show: Bool) {
        hideFooterView(true)
        updateInsetBottom(show)
        isUserInteractionEnabled = show
    }

    fileprivate func hideFooterView(_ flag: Bool) {
        logoImageView?.isHidden = flag
        circleImageView?.isHidden = flag
        statusLabel?.isHidden = flag
    }

    fileprivate func updateInsetBottom(_ show: Bool) {
        if !show {
            scrollView?.insetBottom = 0
            sizeHeight = 0
        } else {
            scrollView?.insetBottom = kRefreshFooterHeight
            sizeHeight = kRefreshFooterHeight
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
        state = .idle
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        placeSubviews()
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if let newScrollView = newSuperview as? UIScrollView {
            removeObservers()
            sizeWidth = newScrollView.sizeWidth
            scrollView = newScrollView
            scrollView?.alwaysBounceVertical = true
            addObservers()

            scrollView?.insetBottom += kRefreshFooterHeight
            originY = scrollView!.contentHeight
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        if state == .willRefresh {
            state = .refreshing
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !isUserInteractionEnabled {
            return
        }

        if keyPath == kRefreshKeyPathContentSize {
            scrollViewContentSizeDidChange(change)
        }

        if keyPath == kRefreshKeyPathContentOffset {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == kRefreshKeyPathPanState {
            scrollViewPanStateDidChange(change)
        }
    }

    fileprivate func executeRefreshingCallback() {
        if let start = start {
            start()
        }
    }

    fileprivate func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        if state != .idle || !isAutomaticallyRefresh || originY == 0 || cellsCount() == 0 || !isShowLoadingView {
            return
        }

        if scrollView!.insetTop + scrollView!.contentHeight > scrollView!.sizeHeight {
            let offsetY = scrollView!.contentHeight - scrollView!.sizeHeight + sizeHeight * triggerAutomaticallyRefreshPercent + scrollView!.insetBottom - sizeHeight

            if scrollView!.offsetY >= offsetY {
                if let newValue = change?[.newKey] as? NSValue, let oldValue = change?[.oldKey] as? NSValue {
                    if newValue.cgPointValue.y < oldValue.cgPointValue.y {
                        return
                    }
                    beginRefreshing()
                }
            }
        }
    }

    fileprivate func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        originY = scrollView!.contentHeight
    }

    fileprivate func scrollViewPanStateDidChange(_ chnage: [NSKeyValueChangeKey : Any]?) {
        if state != .idle || cellsCount() == 0 || !isShowLoadingView {
            return
        }

        if scrollView?.panGestureRecognizer.state == UIGestureRecognizerState.ended {
            if scrollView!.insetTop + scrollView!.contentHeight <= scrollView!.sizeHeight {
                if scrollView!.offsetY >= -scrollView!.insetTop {
                    beginRefreshing()
                }
            } else {
                if scrollView!.offsetY >= scrollView!.contentHeight + scrollView!.insetBottom - scrollView!.sizeHeight {
                    beginRefreshing()
                }
            }
        }
    }

    open class func footerWithLoadingText(_ loadingText: String, startLoading: @escaping () -> ()) -> CustomRefreshFooterView {
        let footer = footerWithRefreshingBlock(startLoading)
        footer.loadingText = loadingText
        return footer
    }

    open class func footerWithRefreshingBlock(_ startLoading: @escaping () -> ()) -> CustomRefreshFooterView {
        let footer = self.init()
        footer.start = startLoading
        return footer
    }

    fileprivate func startAnimation() {
        placeSubviews()
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        rotateAnimation.isRemovedOnCompletion = false
        circleImageView?.layer.add(rotateAnimation, forKey: kCustomRefreshAnimationKey)
    }

    fileprivate func addObservers() {
        let options = NSKeyValueObservingOptions([.new, .old])
        scrollView?.addObserver(self, forKeyPath: kRefreshKeyPathContentOffset, options: NSKeyValueObservingOptions([.new, .old]), context: nil)
        scrollView?.addObserver(self, forKeyPath: kRefreshKeyPathContentSize, options: options, context: nil)
        pan = scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: kRefreshKeyPathPanState, options: options, context: nil)
    }

    fileprivate func removeObservers() {
        superview?.removeObserver(self, forKeyPath: kRefreshKeyPathContentOffset)
        superview?.removeObserver(self, forKeyPath: kRefreshKeyPathContentSize)
        pan?.removeObserver(self, forKeyPath: kRefreshKeyPathPanState)
        pan = nil
    }

    fileprivate func placeSubviews() {
        if cellsCount() != 0 {
            let text = (statusLabel?.text)!
            let font = (statusLabel?.font)!
            let statusLabelWidth: CGFloat =  ceil(text.size(attributes: [NSFontAttributeName:font]).width)
            let originX = (sizeWidth - statusLabelWidth - (circleImageView?.sizeWidth)! - kCustomRefreshFooterMargin) / 2.0
            logoImageView?.center = CGPoint(x: originX+13, y: 20)
            circleImageView?.center = CGPoint(x: originX+13, y: 20)
            statusLabel?.originX = logoImageView!.originX + (circleImageView?.sizeWidth)! + kCustomRefreshFooterMargin
            statusLabel?.size = CGSize(width: statusLabelWidth, height: kRefreshFooterHeight)
        }
    }

    fileprivate func prepare() {
        autoresizingMask = .flexibleWidth
        backgroundColor = UIColor.clear
    }

    fileprivate func beginRefreshing() {
        UIView.animate(withDuration: kCustomRefreshFastAnimationTime, animations: {
            self.alpha = 1.0
        })

        hideFooterView(false)
        pullingPercent = 1.0

        if let _ = window {
            state = .refreshing
        } else {
            if state != .refreshing {
                state = .willRefresh
                setNeedsDisplay()
            }
        }
    }

    open func endRefreshing() {
        state = .idle
    }
}
