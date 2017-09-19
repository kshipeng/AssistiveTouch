//
//  SPAssistiveTouch.h
//  alert
//
//  Created by 康世朋 on 2017/9/18.
//  Copyright © 2017年 康世朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAssistiveTouch : UIView

/** 页面是否有导航栏，默认YES */
@property (nonatomic, assign) BOOL hasNavigationBar;

/** 停止时是否停留在页面边缘，默认YES */
@property (nonatomic, assign) BOOL stopScreenEdge;

/** 停止时的透明度，默认0.4 */
@property (nonatomic, assign) CGFloat alphaForStop;

/** 背景色 */
@property (nonatomic, strong) UIColor *backColor;

/** 圆角，默认圆形 */
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *lightImage;

/** 是否自动改变透明度，默认YES */
@property (nonatomic, assign) BOOL autoChangeAlpha;

+ (instancetype)showOnView:(UIView *)view x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width;
+ (instancetype)showOnView:(UIView *)view x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width click:(void(^)(SPAssistiveTouch *assistive))block;

@end
