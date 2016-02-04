//
//  ViewController.swift
//  RefreshDemo
//
//  Created by ZouLiangming on 16/1/20.
//  Copyright © 2016年 ZouLiangming. All rights reserved.
//

import UIKit

let π = CGFloat(M_PI)

class ViewController: UIViewController {

    var i: CGFloat = 1
    var maxStep: CGFloat = 8
    
    var prevValue : CGFloat = 0.0
    
    var circleLayer: CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startAngle = CGFloat(0)
        let endAngle = 2*π
        let ovalRect = CGRectMake(100, 100, 100, 100)
        
        let ovalPath = UIBezierPath(arcCenter: CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)), radius: CGRectGetWidth(ovalRect), startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = ovalPath.CGPath
        circleLayer.strokeColor = UIColor.blueColor().CGColor
        circleLayer.fillColor = nil //UIColor.clearColor().CGColor
        circleLayer.lineWidth = 10.0
        circleLayer.lineCap = kCALineCapRound
        self.circleLayer = circleLayer
        
        self.view.layer.addSublayer(self.circleLayer!)
        
        self.circleLayer!.strokeStart = 0.0
        //Initial stroke-
        setStrokeEndForLayer(self.circleLayer!, from: 0.0,  to: self.i / self.maxStep, animated: true)
        
        self.i++
        
        
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

