//
//  SPAssistiveTouch.swift
//  Pom91
//
//  Created by 康世朋 on 16/8/4.
//  Copyright © 2016年 SP. All rights reserved.
//

import UIKit

class SPAssistiveTouch: UIView {
    
    var backColor = UIColor.grayColor() {
        didSet {
            backgroundColor = backColor
            assistivaButton.backgroundColor = backColor
        }
    }
    
    
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            assistivaButton.layer.cornerRadius = cornerRadius
        }
    }
    
    
    var normalImage: UIImage? {
        didSet{
           assistivaButton.setBackgroundImage(normalImage, forState: .Normal)
            assistivaButton.layer.cornerRadius = initialFrame.size.width/2
        }
    }
    
    var lightImage: UIImage? {
        didSet{
           assistivaButton.setBackgroundImage(lightImage, forState: .Highlighted)
            assistivaButton.layer.cornerRadius = initialFrame.size.width/2
        }
    }
    
    var alphaForlight: CGFloat = 1 {
        didSet {
            alpha = alphaForlight
            assistivaButton.alpha = alphaForlight
        }
    }
    
    var autoChangeAlpha = true {
        didSet {
            if autoChangeAlpha {
                addTimer()
            }else {
                timer.invalidate()
            }
        }
    }
    
    
    var alphaForStop: CGFloat = 0.5
    var stopScreenEdge = true
    var hasNavigationBar = true
    
    
    private var assistivaButton: UIButton! {
        didSet{
        }
    }
    private var timer = NSTimer()
    private var initialFrame: CGRect!
    private var parentView: UIView!
    func showInView(showOnview viw: UIView, X: CGFloat, Y: CGFloat, width: CGFloat) {
        setupUI(viw, X: X, Y: Y, width: width)

    }
    
    func add_target(target target: AnyObject?, action: Selector) {
        assistivaButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
    }
    
    init(showOnView viw: UIView, X: CGFloat, Y: CGFloat, width: CGFloat) {
        super.init(frame: CGRectZero)
        setupUI(viw, X: X, Y: Y, width: width)
        
    }
    
    init() {
        super.init(frame: CGRectZero)
    }
    
    private func setupUI(viw: UIView, X: CGFloat, Y: CGFloat, width: CGFloat) {
        frame = CGRectMake(X, Y, width, width)
        parentView = viw
        initialFrame = frame
        layer.cornerRadius = width/2
        assistivaButton = UIButton(type: .Custom)
        assistivaButton.frame = CGRectMake(0, 0, width, width)
        assistivaButton.layer.cornerRadius = width/2
        assistivaButton.layer.masksToBounds = true
        assistivaButton.backgroundColor = backColor
        alpha = alphaForStop
        assistivaButton.alpha = alphaForStop
        addSubview(assistivaButton)
        viw.addSubview(self)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(pan(_:))))
        
        addTimer()
    }
    
    private func addTimer() {
        timer = NSTimer(timeInterval: 3, target: self, selector: #selector(changeAlpha), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    @objc private func changeAlpha() {
        UIView.animateWithDuration(1) { 
            self.alpha = self.alphaForStop
            self.assistivaButton.alpha = self.alphaForStop
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc private func pan(panGesture: UIPanGestureRecognizer) {
        timer.invalidate()
        alpha = 1
        assistivaButton.alpha = 1
        let _transX: CGFloat = panGesture.translationInView(self).x
        let _transY: CGFloat = panGesture.translationInView(self).y
        var _maxY: CGFloat
        var _maxX: CGFloat
        
        transform = CGAffineTransformTranslate(transform, _transX, _transY)
        panGesture.setTranslation(CGPointZero, inView: self)
        
        if panGesture.state == .Ended {
            addTimer()
            if frame.origin.y > parentView.bounds.height - initialFrame.size.height - 3 {
                 _maxY = parentView.bounds.height - initialFrame.size.height - 3
                
                resetFrame(x: self.frame.origin.x, y: _maxY, w: self.frame.size.width, h: self.frame.size.height)
            }
            if hasNavigationBar && frame.origin.y <= 67 {
        
                resetFrame(x: self.frame.origin.x, y: 67, w: self.frame.size.width, h: self.frame.size.height)
            }else if !hasNavigationBar && frame.origin.y <= 3 {
                resetFrame(x: self.frame.origin.x, y: 3, w: self.frame.size.width, h: self.frame.size.height)
            }
            if frame.origin.x <= 3 {
                resetFrame(x: 3, y: self.frame.origin.y, w: self.frame.size.width, h: self.frame.size.height)
            }
            if frame.origin.x > parentView.bounds.width - initialFrame.size.width - 3 {
                _maxX = parentView.bounds.width - initialFrame.size.width - 3
                resetFrame(x: _maxX, y: self.frame.origin.y, w: self.frame.size.width, h: self.frame.size.height)
            }
        
            if stopScreenEdge && frame.origin.y < parentView.frame.size.height - frame.size.height - 40 && frame.origin.y > 100{
                if frame.origin.x < parentView.frame.size.width/2 - frame.size.width {
                    resetFrame(x: 3, y: self.frame.origin.y, w: self.frame.size.width, h: self.frame.size.height)
                }else {
                    resetFrame(x: self.parentView.frame.size.width - 3 - self.frame.size.width, y: self.frame.origin.y, w: self.frame.size.width, h: self.frame.size.height)
                }
            }else if stopScreenEdge && frame.origin.y > parentView.frame.size.height - frame.size.height - 40 {
                _maxY = self.parentView.bounds.height - initialFrame.size.height - 3

                resetFrame(x: self.frame.origin.x, y: _maxY, w: self.frame.size.width, h: self.frame.size.height)
            }
            
            if stopScreenEdge && hasNavigationBar && frame.origin.y < 100 {
                resetFrame(x: self.frame.origin.x, y: 67, w: self.frame.size.width, h: self.frame.size.height)
            }else if stopScreenEdge && !hasNavigationBar && frame.origin.y < 100 {
                resetFrame(x: self.frame.origin.x, y: 3, w: self.frame.size.width, h: self.frame.size.height)
            }
        }
        
    }
    
    private func resetFrame(x x: CGFloat, y: CGFloat, w:CGFloat, h: CGFloat) {
        UIView.animateWithDuration(0.5, animations: {
            self.frame = CGRectMake(x, y, w, h)
        })
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
