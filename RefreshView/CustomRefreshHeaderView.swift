//
//  RefreshView.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 16/1/28.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

open class CustomRefreshHeaderView: CustomRefreshView {

    fileprivate var customBackgroundColor = UIColor.clear
    fileprivate var circleLayer: CAShapeLayer?
    fileprivate let angle: CGFloat = 0

    var state: RefreshState? {
        willSet {
            willSetRefreshState(newValue)
        }
        didSet {
            didSetRefreshState()
        }
    }

    lazy var logoImageView: UIImageView? = {
        let image = self.getImage(of: "loading_logo")
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        return imageView
    }()

    lazy var circleImageView: UIImageView? = {
        let image = self.getImage(of: "loading_circle")
        let imageView = UIImageView(image: image)
        self.addSubview(imageView)
        return imageView
    }()

    fileprivate func willSetRefreshState(_ newValue: RefreshState?) {
        if newValue == .idle {
            if state != .refreshing {
                return
            }
            UIView.animate(withDuration: kCustomRefreshSlowAnimationTime, animations: {
                self.scrollView?.insetTop += self.insetTDelta
                self.pullingPercent = 0.0
                self.alpha = 0.0
                }, completion: { (Bool) -> () in
                    self.circleImageView?.layer.removeAnimation(forKey: kCustomRefreshAnimationKey)
                    self.circleImageView?.isHidden = true
                    self.circleLayer?.isHidden = false
            })
        }
    }

    fileprivate func didSetRefreshState() {
        if state == .refreshing {
            UIView.animate(withDuration: kCustomRefreshFastAnimationTime, animations: {
                let top = (self.scrollViewOriginalInset?.top)! + self.sizeHeight
                self.scrollView?.insetTop = top
                self.scrollView?.offsetY = -top
                }, completion: { (Bool) -> () in
                    self.circleImageView?.isHidden = false
                    self.circleLayer?.isHidden = true
                    self.startAnimation()
                    self.executeRefreshingCallback()
            })
        }
    }

    fileprivate func getImage(of name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        let bundle = Bundle(for: classForCoder)
        let image = UIImage(named: name, in: bundle, compatibleWith: traitCollection)
        guard let newImage = image else {
            return UIImage()
        }
        return newImage
    }

    fileprivate func initCircleLayer() {
        if circleLayer == nil {
            circleLayer = CAShapeLayer()
        }
        circleLayer?.shouldRasterize = false
        circleLayer?.contentsScale = UIScreen.main.scale
        layer.addSublayer(circleLayer!)
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
            originX = 0
            scrollView = newScrollView
            scrollView?.alwaysBounceVertical = true
            scrollViewOriginalInset = scrollView?.contentInset
            originInset = scrollView?.contentInset

            addObservers()
        }
    }

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        if state == .willRefresh {
            state = .refreshing
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !isUserInteractionEnabled || isHidden {
            return
        }

        if keyPath == kRefreshKeyPathContentOffset {
            scrollViewContentOffsetDidChange(change)
        }
    }

    fileprivate func executeRefreshingCallback() {
        if let newStart = start {
            newStart()
        }
    }

    fileprivate func changeCircleLayer(to value: CGFloat) {
        let startAngle = kPai/2
        let endAngle = kPai/2+2*kPai*CGFloat(value)
        let ovalRect = CGRect(x: round(sizeWidth/2-6), y: 26, width: 12, height: 12)
        let x = ovalRect.midX
        let y = ovalRect.midY
        let point = CGPoint(x: x, y: y)
        let radius = ovalRect.width
        let ovalPath = UIBezierPath(arcCenter: point, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleLayer?.path = ovalPath.cgPath
        circleLayer?.strokeColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1).cgColor
        circleLayer?.fillColor = nil
        circleLayer?.lineWidth = 2
        circleLayer?.lineCap = kCALineCapRound
    }

    open func autoBeginRefreshing() {
        if state == .idle {
            let offsetY = -scrollViewOriginalInset!.top - kRefreshNotCircleHeight + 14
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
            state = .pulling
            beginRefreshing()
        }
    }

    fileprivate func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        if state == .refreshing {
            if let _ = window {
                var insetT = -scrollView!.offsetY > scrollViewOriginalInset!.top ? -scrollView!.offsetY : scrollViewOriginalInset!.top
                insetT = insetT > sizeHeight + scrollViewOriginalInset!.top ? sizeHeight + scrollViewOriginalInset!.top : insetT
                scrollView?.insetTop = insetT
                insetTDelta = scrollViewOriginalInset!.top - insetT
                return
            } else {
                return
            }
        }

        scrollViewOriginalInset = scrollView?.contentInset
        let offsetY = scrollView!.offsetY
        let happenOffsetY = -scrollViewOriginalInset!.top
        let realOffsetY = happenOffsetY - offsetY - kRefreshNotCircleHeight

        if realOffsetY > 0 {
            if state != .pulling {
                let value = realOffsetY / (kRefreshHeaderHeight - 20)
                if value < 1 {
                    changeCircleLayer(to: value)
                } else {
                    changeCircleLayer(to: 1)
                }
            } else {
                changeCircleLayer(to: 1)
            }
        }

        if offsetY > happenOffsetY {
            return
        }

        let currentPullingPercent = (happenOffsetY - offsetY) / (sizeHeight - 5)
        alpha = currentPullingPercent * 0.8

        if scrollView!.isDragging {
            pullingPercent = currentPullingPercent
            if pullingPercent >= 1 {
                state = .pulling
            } else {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1 {
            pullingPercent = currentPullingPercent
        }
    }

    open class func headerWithRefreshingBlock(_ customBackgroundColor: UIColor = UIColor.clear, startLoading: @escaping () -> ()) -> CustomRefreshHeaderView {
        let header = self.init()
        header.start = startLoading
        header.customBackgroundColor = customBackgroundColor
        return header
    }

    fileprivate func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = -angle
        rotateAnimation.toValue = -angle + CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        circleImageView?.layer.add(rotateAnimation, forKey: kCustomRefreshAnimationKey)
    }

    fileprivate func addObservers() {
        let options = NSKeyValueObservingOptions([.new, .old])
        scrollView?.addObserver(self, forKeyPath: kRefreshKeyPathContentOffset, options: options, context: nil)
    }

    fileprivate func removeObservers() {
        superview?.removeObserver(self, forKeyPath: kRefreshKeyPathContentOffset)
    }

    fileprivate func placeSubviews() {
        if customBackgroundColor != UIColor.clear {
            backgroundColor = customBackgroundColor
        } else {
            backgroundColor = scrollView?.backgroundColor
        }

        logoImageView?.center = CGPoint(x: sizeWidth/2, y: 32)
        circleImageView?.center = CGPoint(x: sizeWidth/2, y: 32)
        circleImageView?.isHidden = true
        initCircleLayer()
        originY = -sizeHeight
    }

    fileprivate func prepare() {
        autoresizingMask = .flexibleWidth
        sizeHeight = kRefreshHeaderHeight
    }

    fileprivate func beginRefreshing() {
        UIView.animate(withDuration: kCustomRefreshFastAnimationTime, animations: { () -> Void in
            self.alpha = 1.0
        })

        pullingPercent = 1.0
        if let _ = window {
            state = .refreshing
        } else {
            if state != .refreshing {
                state = .refreshing
                setNeedsDisplay()
            }
        }
    }

    open func endRefreshing() {
        state = .idle
    }

    func isRefreshing() -> Bool {
        return state == .refreshing || state == .willRefresh
    }
}
