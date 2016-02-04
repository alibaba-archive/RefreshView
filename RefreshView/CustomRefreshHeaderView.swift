//
//  RefreshView.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 16/1/28.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

let CustomRefreshSlowAnimationTime = 0.4
let CustomRefreshFastAnimationTime = 0.25


public enum RefreshState: String {
    case Idle = "Idel"
    case Pulling = "Pulling"
    case Refreshing = "Refreshing"
    case WillRefresh = "WillRefresh"
    case NoMoreData = "NoMoreData"
}

public class CustomRefreshHeaderView: UIView {
    var angle: CGFloat = 0
    var circleLayer: CAShapeLayer?
    var grayerLayer: CAShapeLayer?
    var state : RefreshState? {
        willSet {
            if newValue == .Idle {
                if self.state != .Refreshing {
                    return
                }
                UIView.animateWithDuration(CustomRefreshSlowAnimationTime, animations: {
                    self.scrollView?.insetTop += self.insetTDelta
                    self.pullingPercent = 0.0
                    self.alpha = 0.0
                }, completion: { (Bool) -> () in
                    self.circleImageView?.layer.removeAnimationForKey("rotation")
                    self.circleImageView?.hidden = true
                    self.circleLayer?.hidden = false
                    self.grayerLayer?.hidden = false
                })
            }
        }
        didSet {
            if self.state == .Refreshing {
                UIView.animateWithDuration(CustomRefreshFastAnimationTime, animations: {
                    let top = (self.scrollViewOriginalInset?.top)! + self.sizeHeight;
                    self.scrollView?.insetTop = top
                    self.scrollView?.offsetY = -top
                    }, completion: { (Bool) -> () in
                        self.circleImageView?.hidden = false
                        self.circleLayer?.hidden = true
                        self.grayerLayer?.hidden = true
                        self.startAnimation()
                        self.executeRefreshingCallback()
                })
            }
        }
    }
    
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

    func initCircleLayer() {
        self.circleLayer = CAShapeLayer()
        self.circleLayer?.shouldRasterize = false
        self.circleLayer?.contentsScale = UIScreen.mainScreen().scale
        self.layer.addSublayer(self.circleLayer!)
    }
    
    func initGrayerLayer() {
        let startAngle = CGFloat(0)
        let endAngle = 2*π
        let ovalRect = CGRectMake(round(self.sizeWidth/2-6), 26, 12, 12)
        
        let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)), radius: CGRectGetWidth(ovalRect), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = ovalPath.CGPath
        layer.strokeColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).CGColor
        layer.fillColor = nil
        layer.lineWidth = 2
        layer.lineCap = kCALineCapRound
        self.grayerLayer = layer
        self.layer.addSublayer(self.grayerLayer!)
    }
    
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
            self.scrollViewOriginalInset = self.scrollView?.contentInset;
            self.originInset = self.scrollView?.contentInset
            
            self.addObservers()
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
        if self.state == .Refreshing {
            if let _ = self.window {
                var insetT = -self.scrollView!.offsetY > self.scrollViewOriginalInset?.top ? -self.scrollView!.offsetY : self.scrollViewOriginalInset?.top
                insetT = insetT > self.sizeHeight + (self.scrollViewOriginalInset?.top)! ? self.sizeHeight + (self.scrollViewOriginalInset?.top)! : insetT
                self.scrollView?.insetTop = insetT!
                self.insetTDelta = self.scrollViewOriginalInset!.top - insetT!
                return
            } else {
                return
            }
        }
        
        self.scrollViewOriginalInset = self.scrollView?.contentInset
        let offsetY = self.scrollView!.offsetY
        let happenOffsetY = -self.scrollViewOriginalInset!.top
        
        if offsetY < -80 {
            let value = (offsetY + 80) / (-RefreshHeaderHeight)
            if value <= 1 {
                self.changeCircleLayer(value)
            } else {
                self.changeCircleLayer(1)
            }
        }
        
        if offsetY > happenOffsetY {
            return
        }
        
        let normal2pullingOffsetY = happenOffsetY - self.sizeHeight
        let pullingPercent = (happenOffsetY - offsetY) / self.sizeHeight
        self.alpha = pullingPercent * 0.8
        
        if self.scrollView!.dragging {
            self.pullingPercent = pullingPercent;
            if self.state == .Idle && offsetY < normal2pullingOffsetY {
                self.state = .Pulling
            } else if self.state == .Pulling && offsetY >= normal2pullingOffsetY {
                self.state = .Idle
            }
        } else if self.state == .Pulling {
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    func changeCircleLayer(value: CGFloat) {
        let startAngle = π/2
        let endAngle = π/2+2*π*CGFloat(value)
        let ovalRect = CGRectMake(round(self.sizeWidth/2-6), 26, 11, 11)
        
        let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)), radius: CGRectGetWidth(ovalRect), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.circleLayer?.path = ovalPath.CGPath
        self.circleLayer?.strokeColor = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1).CGColor
        self.circleLayer?.fillColor = nil
        self.circleLayer?.lineWidth = 2
        self.circleLayer?.lineCap = kCALineCapRound
    }
    
    func scrollViewContentSizeDidChange(chnage: [String : AnyObject]?) {
        
    }
    
    func scrollViewPanStateDidChange(chnage: [String : AnyObject]?) {
        
    }
    
    public class func headerWithRefreshingBlock(start: () -> ()) -> CustomRefreshHeaderView {
        let header = self.init()
        header.start = start
        return header
    }
    
    func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = -angle
        rotateAnimation.toValue = -angle + CGFloat(M_PI * 2.0)
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
        self.logoImageView?.center = CGPointMake(self.sizeWidth/2, 32)
        self.circleImageView?.center = CGPointMake(self.sizeWidth/2, 32)
        self.circleImageView?.hidden = true
        //self.initGrayerLayer()
        self.initCircleLayer()
        self.originY = -self.sizeHeight
    }
    
    func prepare() {
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        self.sizeHeight = RefreshHeaderHeight
    }
    
    func beginRefreshing() {
        UIView.animateWithDuration(CustomRefreshFastAnimationTime) { () -> Void in
            self.alpha = 1.0
        }
        
        self.pullingPercent = 1.0;
        if let _ = self.window {
            self.state = .Refreshing
        } else {
            if self.state != .Refreshing {
                self.state = .Refreshing
                self.setNeedsDisplay()
            }
        }
    }
    
    public func endRefreshing() {
        self.state = .Idle
    }
    
    func isRefreshing() -> Bool {
        return self.state == .Refreshing || self.state == .WillRefresh
    }
}
