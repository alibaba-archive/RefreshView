//
//  ThirdViewController.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 2/3/16.
//  Copyright © 2016 ZouLiangming. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var i: CGFloat = 1
    var maxStep: CGFloat = 8
    
    var prevValue : CGFloat = 0.0
    
    var circleLayer: CAShapeLayer?
    var grayerLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initGrayerLayer()
        self.initCircleLayer()
    }
    
    func initCircleLayer() {
        self.circleLayer = CAShapeLayer()
        self.view.layer.addSublayer(self.circleLayer!)
        
        self.circleLayer!.strokeStart = 0.0
        //Initial stroke-
        //setStrokeEndForLayer(self.circleLayer!, from: 0.0,  to: self.i / self.maxStep, animated: true)
        
        self.i++
    }
    
    func initGrayerLayer() {
        let startAngle = CGFloat(0)
        let endAngle = 2*π
        let ovalRect = CGRectMake(100, 200, 13, 13)
        
        let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)), radius: CGRectGetWidth(ovalRect), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        let layer = CAShapeLayer()
        layer.path = ovalPath.CGPath
        layer.strokeColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1).CGColor
        layer.fillColor = nil
        layer.lineWidth = 2.0
        layer.lineCap = kCALineCapRound
        self.grayerLayer = layer
        
        self.view.layer.addSublayer(self.grayerLayer!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func buttonAnimate(sender: UIButton) {
        if self.i <= self.maxStep {
            
            setStrokeEndForLayer(self.circleLayer!, from: (self.i - 1 ) / self.maxStep,  to: self.i / self.maxStep, animated: true)
            self.i++
        }
    }
    
    @IBAction func valueChanged(sender: UISlider) {
        self.changeCircleLayer(CGFloat(sender.value))
    }
    
    func changeCircleLayer(value: CGFloat) {
        let startAngle = π/2
        let endAngle = π/2+2*π*CGFloat(value)
        let ovalRect = CGRectMake(100, 200, 13, 13)
        
        let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)), radius: CGRectGetWidth(ovalRect), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        self.circleLayer?.path = ovalPath.CGPath
        self.circleLayer?.strokeColor = UIColor(red: 56/255, green: 56/255, blue: 56/255, alpha: 1).CGColor
        self.circleLayer?.fillColor = nil
        self.circleLayer?.lineWidth = 2.0
        self.circleLayer?.lineCap = kCALineCapRound
    }
    
    func setStrokeEndForLayer(layer: CALayer,  var from:CGFloat, to: CGFloat, animated: Bool)
    {
        
        self.circleLayer!.strokeEnd = to
        
        if animated
        {
            
            //Check if there is any existing animation is in progress, if so override, the from value
            if let circlePresentationLayer = self.circleLayer!.presentationLayer()
            {
                from = circlePresentationLayer.strokeEnd
            }
            
            //Remove any on going animation
            if (self.circleLayer?.animationForKey("arc animation") as? CABasicAnimation != nil)
            {
                //Remove the current animation
                self.circleLayer!.removeAnimationForKey("arc animation")
            }
            
            
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            // here i set the duration
            anim.duration = 1
            anim.fromValue = from
            anim.toValue = to
            
            
            self.circleLayer!.addAnimation(anim, forKey: "arc animation")
        }
    }
}