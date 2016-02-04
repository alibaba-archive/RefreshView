//
//  RefreshView.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 16/1/28.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

public class CustomRefreshFooterView: UIView {
    
    var state : RefreshState? {
        didSet {
            if self.state == .Refreshing {
                self.startAnimation()
                self.executeRefreshingCallback()
            } else if self.state == .Idle {
                self.circleImageView?.layer.removeAnimationForKey("rotation")
            }
        }
    }
    
    override public var hidden: Bool {
        willSet(newValue) {
            if !self.hidden && newValue {
                self.state = .Idle
                self.scrollView?.insetBottom -= self.sizeHeight
            } else {
                self.scrollView?.insetBottom += self.sizeHeight
                self.sizeHeight = self.scrollView!.contentHeight
            }
        }
    }
    
    var isAutomaticallyHidden: Bool = false
    var isAutomaticallyRefresh: Bool = true
    var triggerAutomaticallyRefreshPercent: CGFloat = 0.1
    
    var pan: UIPanGestureRecognizer?
    var scrollView: UIScrollView?
    var pullingPercent: CGFloat?
    var start: (() -> ())?
    var insetTDelta: CGFloat = 0
    var scrollViewOriginalInset: UIEdgeInsets?
    var originInset: UIEdgeInsets?
    
    lazy var logoImageView: UIImageView? = {
        let image = self.getImage("refresh_logo")
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        return imageView
    }()
    
    lazy var circleImageView: UIImageView? = {
        let image = self.getImage("refresh_circle")
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        return imageView
    }()
    
    func getImage(name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        let bundle = NSBundle(forClass: self.classForCoder)
        guard let image = UIImage(named: name, inBundle: bundle, compatibleWithTraitCollection: traitCollection) else { return UIImage() }
        
        return image
    }
    
    lazy var statusLabel: UILabel? = {
       let label = UILabel()
        label.text = "正在加载更多..."
        self.addSubview(label)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepare()
        self.state = .Idle
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubviews()
    }
    
    override public func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if let newScrollView = newSuperview as? UIScrollView {
            self.removeObservers()
            self.sizeWidth = newScrollView.sizeWidth
            self.originX = 0
            self.scrollView = newScrollView
            self.scrollView?.alwaysBounceVertical = true
            self.scrollViewOriginalInset = self.scrollView?.contentInset
            self.addObservers()
            
            self.hidden = false
            if self.hidden == false {
                self.scrollView?.insetBottom += self.sizeHeight;
            }
            self.originY = self.scrollView!.contentHeight;
        } else {
            
            if self.hidden == false {
                self.scrollView?.insetBottom -= self.sizeHeight
            }
        }
    }
    
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if self.state == .WillRefresh {
            self.state = .Refreshing
        }
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !self.userInteractionEnabled {
            return
        }
        
        if keyPath == RefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change)
        }
        
        if self.hidden {
            return
        }
        
        if keyPath == RefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change)
        } else if keyPath == RefreshKeyPathPanState {
            self.scrollViewPanStateDidChange(change)
        }
    }
    
    func executeRefreshingCallback() {
        if let start = self.start {
            start()
        }
    }
    
    func scrollViewContentOffsetDidChange(change: [String : AnyObject]?) {
        if self.state != .Idle || !self.isAutomaticallyRefresh || self.originY == 0 {
            return
        }
        
        if self.scrollView!.insetTop + self.scrollView!.contentHeight > self.scrollView!.sizeHeight {
            if self.scrollView!.offsetY >= self.scrollView!.contentHeight - self.scrollView!.sizeHeight + self.sizeHeight * self.triggerAutomaticallyRefreshPercent + self.scrollView!.insetBottom - self.sizeHeight {
                
                if let old = change!["old"]!.CGPointValue {
                    if let new = change!["new"]!.CGPointValue {
                        if new.y < old.y {
                            return
                        }
                        self.beginRefreshing()
                    }
                }
            }
        }
    }
    
    func scrollViewContentSizeDidChange(change: [String : AnyObject]?) {
        self.originY = self.scrollView!.contentHeight
    }
    
    func scrollViewPanStateDidChange(chnage: [String : AnyObject]?) {
        if self.state != .Idle {
            return
        }
        
        if self.scrollView?.panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if self.scrollView!.insetTop + self.scrollView!.contentHeight <= self.scrollView!.sizeHeight {
                if self.scrollView!.offsetY >= -self.scrollView!.insetTop {
                    self.beginRefreshing()
                }
            } else {
                if self.scrollView!.offsetY >= self.scrollView!.contentHeight + self.scrollView!.insetBottom - self.scrollView!.sizeHeight {
                    self.beginRefreshing()
                }
            }
        }
    }
    
    public class func footerWithRefreshingBlock(start: () -> ()) -> CustomRefreshFooterView {
        let footer = self.init()
        footer.start = start
        return footer
    }
    
    func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float(CGFloat.max)
        self.circleImageView?.layer.addAnimation(rotateAnimation, forKey: "rotation")
    }
    
    func addObservers() {
        let options = NSKeyValueObservingOptions([.New, .Old])
        self.scrollView?.addObserver(self, forKeyPath: RefreshKeyPathContentOffset, options: NSKeyValueObservingOptions([.New, .Old]), context: nil)
        self.scrollView?.addObserver(self, forKeyPath: RefreshKeyPathContentSize, options: options, context: nil)
        self.pan = self.scrollView?.panGestureRecognizer
        self.pan?.addObserver(self, forKeyPath: RefreshKeyPathPanState, options: options, context: nil)
    }
    
    func removeObservers() {
        self.superview?.removeObserver(self, forKeyPath: RefreshKeyPathContentOffset)
        self.superview?.removeObserver(self, forKeyPath: RefreshKeyPathContentSize)
        self.pan?.removeObserver(self, forKeyPath: RefreshKeyPathPanState)
        self.pan = nil
    }
    
    func placeSubviews() {
        let originX = (self.sizeWidth - 120 - 26 - 10)/2.0
        self.logoImageView?.center = CGPointMake(originX, 20)
        self.circleImageView?.center = CGPointMake(originX, 20)
        self.statusLabel?.originX = self.logoImageView!.originX + 40
        self.statusLabel?.size = CGSizeMake(120, RefreshFooterHeight)
    }

    func prepare() {
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.grayColor()
        
        self.sizeHeight = RefreshFooterHeight
        self.isAutomaticallyHidden = false
        
        self.isAutomaticallyRefresh = true
        self.triggerAutomaticallyRefreshPercent = 0.0
    }
    
    func beginRefreshing() {
        UIView.animateWithDuration(CustomRefreshFastAnimationTime) {
            self.alpha = 1.0
        }
        
        self.pullingPercent = 1.0
        if let _ = self.window {
            self.state = .Refreshing
        } else {
            if self.state != .Refreshing {
                self.state = .WillRefresh
                self.setNeedsDisplay()
            }
        }
    }
    
    public func endRefreshing() {
        self.state = .Idle
    }
    
    func endRefreshingWithNoMoreData() {
        self.state = .NoMoreData
    }
    
    func noticeNoMoreData() {
        self.endRefreshingWithNoMoreData()
    }
    
    func resetNoMoreData() {
        self.state = .Idle
    }
    
    func isRefreshing() -> Bool {
        return self.state == .Refreshing || self.state == .WillRefresh
    }
}
