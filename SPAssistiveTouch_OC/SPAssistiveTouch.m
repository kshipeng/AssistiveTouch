//
//  SPAssistiveTouch.m
//  alert
//
//  Created by 康世朋 on 2017/9/18.
//  Copyright © 2017年 康世朋. All rights reserved.
//

#import "SPAssistiveTouch.h"

@interface SPAssistiveTouch ()

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, strong) UIButton *assistivaButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat transX;
@property (nonatomic, assign) CGFloat transY;
@property (nonatomic, assign) CGFloat maxX;
@property (nonatomic, assign) CGFloat maxY;

@property (nonatomic, copy) void(^clickBlock)(SPAssistiveTouch *touch);

@end

@implementation SPAssistiveTouch

+ (instancetype)showOnView:(UIView *)view x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width {
    SPAssistiveTouch *ass = [[SPAssistiveTouch alloc]init];
    [ass setupUIWithView:view x:x y:y width:width];
    return ass;
}

+ (instancetype)showOnView:(UIView *)view x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width click:(void (^)(SPAssistiveTouch *))block {
    SPAssistiveTouch *ass = [[SPAssistiveTouch alloc]init];
    ass.clickBlock = block;
    [ass setupUIWithView:view x:x y:y width:width];
    return ass;
}

- (void)setupUIWithView:(UIView *)view x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width {
    
    self.frame = CGRectMake(x, y, width, width);
    _parentView = view;
    _initialFrame = self.frame;
    _stopScreenEdge = YES;
    _hasNavigationBar = YES;
    _alphaForStop = 0.4;
    _autoChangeAlpha = YES;
    self.layer.cornerRadius = width/2;
    _assistivaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _assistivaButton.frame = CGRectMake(0, 0, width, width);
    _assistivaButton.layer.cornerRadius = width/2;
    _assistivaButton.layer.masksToBounds = YES;
    _assistivaButton.backgroundColor = [UIColor blackColor];
    self.alpha = _alphaForStop;
    _assistivaButton.alpha = _alphaForStop;
    [_assistivaButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_assistivaButton];
    [view addSubview:self];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGesture];
}

- (void)pan:(UIPanGestureRecognizer *)panGesture {
    [_timer invalidate];
    self.alpha = 1;
    _assistivaButton.alpha = 1;
    _transX = [panGesture translationInView:self].x;
    _transY = [panGesture translationInView:self].y;
    panGesture.view.center = CGPointMake(panGesture.view.center.x + _transX, panGesture.view.center.y + _transY);
    [panGesture setTranslation:CGPointZero inView:self];
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (_autoChangeAlpha) {
           [self addTimer];
        }else {
            [_timer invalidate];
            _timer = nil;
        }
        
        if (self.frame.origin.y > _parentView.bounds.size.height - _initialFrame.size.height - 3) {
            _maxY = _parentView.bounds.size.height - _initialFrame.size.height - 3;
            [self resetFrameX:self.frame.origin.x y:_maxY w:self.frame.size.width h:self.frame.size.height];
        }
        if (_hasNavigationBar && self.frame.origin.y <= 67) {
            [self resetFrameX:self.frame.origin.x y:67 w:self.frame.size.width h:self.frame.size.height];
        }else if (!_hasNavigationBar && self.frame.origin.y <= 3) {
            [self resetFrameX:self.frame.origin.x y:3 w:self.frame.size.width h:self.frame.size.height];
        }
        if (self.frame.origin.x <= 3) {
            [self resetFrameX:3 y:self.frame.origin.y w:self.frame.size.width h:self.frame.size.height];
        }
        if (self.frame.origin.x > _parentView.bounds.size.width - _initialFrame.size.width - 3) {
            _maxX = _parentView.bounds.size.width - _initialFrame.size.width - 3;
            [self resetFrameX:_maxX y:self.frame.origin.y w:self.frame.size.width h:self.frame.size.height];
        }
        
        if (_stopScreenEdge && self.frame.origin.y < _parentView.frame.size.height - self.frame.size.height - 40 && self.frame.origin.y > 100) {
            if (self.frame.origin.x < _parentView.frame.size.width/2 - self.frame.size.width) {
                [self resetFrameX:3 y:self.frame.origin.y w:self.frame.size.width h:self.frame.size.height];
            }else {
                [self resetFrameX:_parentView.frame.size.width-3-self.frame.size.width y:self.frame.origin.y w:self.frame.size.width h:self.frame.size.height];
                
            }
        }else if (_stopScreenEdge && self.frame.origin.y > _parentView.frame.size.height - self.frame.size.height - 40) {
            _maxY = self.parentView.bounds.size.height - _initialFrame.size.height - 3;
            [self resetFrameX:self.frame.origin.x y:_maxY w:self.frame.size.width h:self.frame.size.height];
        }
        
        if (_stopScreenEdge && _hasNavigationBar && self.frame.origin.y < 100) {
            [self resetFrameX:self.frame.origin.x y:67 w:self.frame.size.width h:self.frame.size.height];
        }else if (_stopScreenEdge && !_hasNavigationBar && self.frame.origin.y < 100) {
            [self resetFrameX:self.frame.origin.x y:3 w:self.frame.size.width h:self.frame.size.height];
        }
    }
}

- (void)setBackColor:(UIColor *)backColor {
    _backColor = backColor;
    self.backgroundColor = backColor;
    _assistivaButton.backgroundColor = backColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    _assistivaButton.layer.cornerRadius = cornerRadius;
}

- (void)setNormalImage:(UIImage *)normalImage {
    _normalImage = normalImage;
    [_assistivaButton setBackgroundImage:normalImage forState:UIControlStateNormal];
}

- (void)setLightImage:(UIImage *)lightImage {
    _lightImage = lightImage;
    [_assistivaButton setBackgroundImage:lightImage forState:UIControlStateHighlighted];
}

- (void)setAlphaForStop:(CGFloat)alphaForStop {
    _alphaForStop = alphaForStop;
    self.alpha = alphaForStop;
    _assistivaButton.alpha = alphaForStop;
}

- (void)setAutoChangeAlpha:(BOOL)autoChangeAlpha {
    _autoChangeAlpha = autoChangeAlpha;
    if (_autoChangeAlpha) {
        [self addTimer];
    }else {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)resetFrameX:(CGFloat)x y:(CGFloat)y w:(CGFloat)width h:(CGFloat)height {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(x, y, width, height);
    }];
}

- (void)addTimer {
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(changeAlpha) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)buttonClick {
    if (_autoChangeAlpha) {
        [self addTimer];
    }else {
        [_timer invalidate];
        _timer = nil;
    }
    self.alpha = 1;
    _assistivaButton.alpha = 1;
    !_clickBlock? :_clickBlock(self);
}

- (void)changeAlpha {
    [UIView animateWithDuration:0.7 animations:^{
        self.alpha = self.alphaForStop;
        self.assistivaButton.alpha = self.alphaForStop;
    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
