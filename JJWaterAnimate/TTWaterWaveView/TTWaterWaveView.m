//
//  TTWaterWaveView.m
//  TTAnimation
//
//  Created by Lision on 2017/3/29.
//  Copyright © 2017年 Lision. All rights reserved.
//

#import "TTWaterWaveView.h"

@interface TTWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;
@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;
@property (nonatomic, strong) CAGradientLayer *firstColorLayer;
@property (nonatomic, strong) CAGradientLayer *secondColorLayer;

@end

@implementation TTWaterWaveView {
    CGFloat waveAmplitude;                  // amplitude 振幅
    CGFloat waveCycle;                      // cycle 周期
    CGFloat waveSpeed;                      // horizontal speed 横向偏移速度
    CGFloat waveGrowth;                     // vertical speed  纵向偏移速度
    
    CGFloat waterWaveHeight;                // target height  波浪目标高度
    CGFloat waterWaveWidth;                 // the width of a cycle  一个周期的破文宽度
    CGFloat offsetX;                        // X axis displacement x轴位移
    CGFloat currentWavePointY;              // current water wave Y 当前波浪的Y轴值
    
    float variable;               //仿真系数          // variable parameters are more realistic to simulate ripple ripples
    BOOL increase;
    TTWaterWaveAnimateType _animateType;
}

#pragma mark - Interface
- (void)startWave {
    _animateType = TTWaterWaveAnimateTypeShow;
    [self resetProperty];
    
    if (_firstWaveLayer == nil) {
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        
        _firstColorLayer = [CAGradientLayer layer];
        _firstColorLayer.startPoint = CGPointMake(0, 0);
        _firstColorLayer.endPoint = CGPointMake(0, 1);
        _firstColorLayer.colors = @[(id)[_firstWaveColor colorWithAlphaComponent:0.5].CGColor, (id)[_firstWaveColor colorWithAlphaComponent:0.0].CGColor];
        _firstColorLayer.frame = self.bounds;
        [_firstColorLayer setMask:_firstWaveLayer];
        [self.layer addSublayer:_firstColorLayer];
    }
    
    if (_secondWaveLayer == nil) {
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
        
        _secondColorLayer = [CAGradientLayer layer];
        _secondColorLayer.startPoint = CGPointMake(1, 1);
        _secondColorLayer.endPoint = CGPointMake(1, 1);
        _secondColorLayer.colors = @[(id)[_secondWaveColor colorWithAlphaComponent:0.5].CGColor, (id)[_secondWaveColor colorWithAlphaComponent:0.0].CGColor];
        _secondColorLayer.frame = self.bounds;
        [_secondColorLayer setMask:_secondWaveLayer];
        [self.layer addSublayer:_secondColorLayer];
    }
    
    if (_waveDisplaylink) {
        [self stopWave];
    }
    
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopWave {
    _animateType = TTWaterWaveAnimateTypeHide;
}

- (void)reset {
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
    
    [self resetProperty];
    
    [_firstWaveLayer removeFromSuperlayer];
    _firstWaveLayer = nil;
    [_secondWaveLayer removeFromSuperlayer];
    _secondWaveLayer = nil;
}

- (void)removeFromParentView {
    [self reset];
    [self removeFromSuperview];
}

#pragma mark - Setter
- (void)setFirstWaveColor:(UIColor *)firstWaveColor {
    _firstWaveColor = firstWaveColor;
    _firstColorLayer.colors = @[(id)[firstWaveColor colorWithAlphaComponent:1].CGColor, (id)[firstWaveColor colorWithAlphaComponent:1.0].CGColor];
}

- (void)setSecondWaveColor:(UIColor *)secondWaveColor {
    _secondWaveColor = secondWaveColor;
    _secondColorLayer.colors = @[(id)[secondWaveColor colorWithAlphaComponent:1].CGColor, (id)[secondWaveColor colorWithAlphaComponent:1].CGColor];
}

- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    [self resetProperty];
}

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        
        [self setUp];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        
        [self setUp];
    }
    
    return self;
}

- (void)setUp {
    waterWaveHeight = self.frame.size.height / 2;
    waterWaveWidth  = self.frame.size.width;
    _firstWaveColor = [UIColor colorWithRed:223 / 255.0 green:83 / 255.0 blue:64 / 255.0 alpha:1];
    _secondWaveColor = [UIColor colorWithRed:236 / 255.0f green:90 / 255.0f blue:66 / 255.0f alpha:1];
    
    waveGrowth = 0.85;//波浪上涨的速度
    waveSpeed = 0.3 / M_PI;//波浪的速度
    
    [self resetProperty];
}

- (void)resetProperty {
    currentWavePointY = self.frame.size.height ;
    
    variable = 1.6;
    increase = YES;
    
    offsetX = 90;
}

- (void)dealloc {
    [self reset];
}

#pragma mark - Overwrite
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    waterWaveHeight = self.frame.size.height / 2;
    waterWaveWidth  = self.frame.size.width;
    if (waterWaveWidth > 0) {
        waveCycle = 1.29 * M_PI / waterWaveWidth;
    }
    
    if (currentWavePointY <= 0) {
        currentWavePointY = self.frame.size.height;
    }
}

- (void)animateWave {
    if (increase) {
        variable += 0.01;
    } else {
        variable -= 0.01;
    }
    
    if (variable <= 1) {
        increase = YES;
    }
    
    if (variable >= 1.6) {
        increase = NO;
    }
    
    waveAmplitude = variable * 15;
}

- (void)getCurrentWave:(CADisplayLink *)displayLink {
    [self animateWave];
    
    if (TTWaterWaveAnimateTypeShow == _animateType && currentWavePointY > 2 * waterWaveHeight * (1 - _percent)) {
        currentWavePointY -= waveGrowth;
    } else if (TTWaterWaveAnimateTypeHide == _animateType && currentWavePointY < 2 * waterWaveHeight) {
        currentWavePointY += waveGrowth;
    } else if (TTWaterWaveAnimateTypeHide == _animateType && currentWavePointY == 2 * waterWaveHeight) {
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
        [self removeFromParentView];
    }
    
    offsetX -= waveSpeed;
    
    [self setCurrentFirstWaveLayerPath];
    [self setCurrentSecondWaveLayerPath];
}

- (void)setCurrentFirstWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= waterWaveWidth; x++) {
        y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

- (void)setCurrentSecondWaveLayerPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= waterWaveWidth; x++) {
        y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondWaveLayer.path = path;
    CGPathRelease(path);
}

@end
