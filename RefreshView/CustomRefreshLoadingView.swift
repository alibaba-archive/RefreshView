//
//  CustomRefreshLoadingView.swift
//  RefreshView
//
//  Created by bruce on 16/5/20.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

open class CustomRefreshLoadingView: UIView {
    fileprivate var scrollView: UIScrollView?
    fileprivate var imageViewLogo: UIImageView!
    fileprivate var imageViewLoading: UIImageView!

    open var offsetX: CGFloat?
    open var offsetY: CGFloat?
    fileprivate let loadingWidth: CGFloat = 26.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    fileprivate func prepare() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    fileprivate func placeSubviews() {
        var originX: CGFloat = 0
        var originY: CGFloat = 0
        if let offsetX = offsetX {
            originX = offsetX
        } else {
            originX = (sizeWidth - loadingWidth) / 2.0
        }
        if let offsetY = offsetY {
            originY = offsetY
        } else {
            originY = (sizeHeight - loadingWidth) / 2.0 - 30
        }
        self.imageViewLogo.frame = CGRect(x: originX, y: originY, width: loadingWidth, height: loadingWidth)
        self.imageViewLoading.frame = CGRect(x: originX, y: originY, width: loadingWidth, height: loadingWidth)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if let newScrollView = newSuperview as? UIScrollView {
            scrollView = newScrollView
            scrollView?.bounces = false
            sizeWidth = newScrollView.sizeWidth
            sizeHeight = newScrollView.sizeHeight
            commonInit()
            backgroundColor = scrollView?.backgroundColor
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        placeSubviews()
    }

    fileprivate func commonInit() {
        self.imageViewLogo = UIImageView()
        self.imageViewLoading = UIImageView()
        self.imageViewLogo.image = getImage(of: "loading_logo")
        self.imageViewLoading.image = getImage(of: "loading_circle")
        self.imageViewLogo.backgroundColor = UIColor.clear
        self.imageViewLoading.backgroundColor = UIColor.clear
        self.addSubview(self.imageViewLogo)
        self.addSubview(self.imageViewLoading)
        self.placeSubviews()
    }

    fileprivate func getImage(of name: String) -> UIImage {
        let traitCollection = UITraitCollection(displayScale: 3)
        let bundle = Bundle(for: self.classForCoder)
        guard let image = UIImage(named: name, in: bundle, compatibleWith: traitCollection) else { return UIImage() }

        return image
    }

    open func startAnimation() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        rotateAnimation.isRemovedOnCompletion = false
        self.imageViewLoading.layer.add(rotateAnimation, forKey: "rotation")
    }

    open func stopAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0
            self.scrollView?.bounces = true
        }, completion: { (competition) -> Void in
            self.imageViewLoading.layer.removeAnimation(forKey: "rotation")
            self.removeFromSuperview()
            self.alpha = 1
        })
    }
}
