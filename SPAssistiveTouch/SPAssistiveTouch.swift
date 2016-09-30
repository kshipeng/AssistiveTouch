//
//  SPAssistiveTouch.swift
//  Pom91
//
//  Created by 康世朋 on 16/8/4.
//  Copyright © 2016年 SP. All rights reserved.
//

import UIKit

class SPAssistiveTouch: UIView {
    
    var backColor = UIColor.gray {
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
           assistivaButton.setBackgroundImage(normalImage, for: UIControlState())
            assistivaButton.layer.cornerRadius = initialFrame.size.width/2
        }
    }
    
    var lightImage: UIImage? {
        didSet{
           assistivaButton.setBackgroundImage(lightImage, for: .highlighted)
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
    
    
    fileprivate var assistivaButton: UIButton! {
        didSet{
        }
    }
    fileprivate var timer = Timer()
    fileprivate var initialFrame: CGRect!
    fileprivate var parentView: UIView!
    func showInView(showOnview viw: UIView, X: CGFloat, Y: CGFloat, width: CGFloat) {
        setupUI(viw, X: X, Y: Y, width: width)

    }
    
    func add_target(target: AnyObject?, action: Selector) {
        assistivaButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    init(showOnView viw: UIView, X: CGFloat, Y: CGFloat, width: CGFloat) {
        super.init(frame: CGRect.zero)
        setupUI(viw, X: X, Y: Y, width: width)
        
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    fileprivate func setupUI(_ viw: UIView, X: CGFloat, Y: CGFloat, width: CGFloat) {
        frame = CGRect(x: X, y: Y, width: width, height: width)
        parentView = viw
        initialFrame = frame
        layer.cornerRadius = width/2
        assistivaButton = UIButton(type: .custom)
        assistivaButton.frame = CGRect(x: 0, y: 0, width: width, height: width)
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
    
    fileprivate func addTimer() {
        timer = Timer(timeInterval: 3, target: self, selector: #selector(changeAlpha), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc fileprivate func changeAlpha() {
        UIView.animate(withDuration: 1, animations: { 
            self.alpha = self.alphaForStop
            self.assistivaButton.alpha = self.alphaForStop
        }) 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @objc fileprivate func pan(_ panGesture: UIPanGestureRecognizer) {
        timer.invalidate()
        alpha = 1
        assistivaButton.alpha = 1
        let _transX: CGFloat = panGesture.translation(in: self).x
        let _transY: CGFloat = panGesture.translation(in: self).y
        var _maxY: CGFloat
        var _maxX: CGFloat
        
        transform = transform.translatedBy(x: _transX, y: _transY)
        panGesture.setTranslation(CGPoint.zero, in: self)
        
        if panGesture.state == .ended {
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
    
    fileprivate func resetFrame(x: CGFloat, y: CGFloat, w:CGFloat, h: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: x, y: y, width: w, height: h)
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
