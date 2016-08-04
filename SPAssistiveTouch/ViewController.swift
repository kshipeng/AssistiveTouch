//
//  ViewController.swift
//  SPAssistiveTouch
//
//  Created by 康世朋 on 16/8/4.
//  Copyright © 2016年 SP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var spAssistiveTouch = SPAssistiveTouch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //或者像这样
        //spAssistiveTouch = SPAssistiveTouch(showOnView: self.view, X: 3, Y: 100, width: 40)
        spAssistiveTouch.showInView(showOnview: self.view, X: 3, Y: 200, width: 40)
        
        //设置平常时的图片
        spAssistiveTouch.normalImage = UIImage(named: "1.jpg")
        //设置高亮时的图片
        spAssistiveTouch.lightImage = UIImage(named: "2.jpg")
        //是否自动停留在屏幕边缘 默认true
        spAssistiveTouch.stopScreenEdge = true
        //设置背景色 默认灰色
        spAssistiveTouch.backColor = UIColor.redColor()
        //设置停止时的透明度 默认0.5
        spAssistiveTouch.alphaForStop = 0.6
        //设置父视图是否有导航 默认为true
        spAssistiveTouch.hasNavigationBar = false
        //设置是否自动改变透明度 默认为true
        spAssistiveTouch.autoChangeAlpha = true
        //添加点击事件
        spAssistiveTouch.add_target(target: self, action: #selector(tap))

    }
    func tap() {
        /*设值点击时的透明度
         默认为1
         */
        spAssistiveTouch.alphaForlight = 0.8
        let alert:UIAlertController = UIAlertController.init(title: "哈哈哈", message: "成功了😄", preferredStyle: .Alert)
        alert.addAction(UIAlertAction.init(title: "好", style: .Default, handler:{Void in   }))
        self.presentViewController(alert, animated: true, completion: { })
        print("seccess😄")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

