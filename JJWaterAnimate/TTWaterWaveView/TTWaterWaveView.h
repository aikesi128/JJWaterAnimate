//
//  TTWaterWaveView.h
//  TTAnimation
//
//  Created by Lision on 2017/3/29.
//  Copyright © 2017年 Lision. All rights reserved.
//
//  An animated view with a gradient of water.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TTWaterWaveAnimateType) {
    TTWaterWaveAnimateTypeShow,
    TTWaterWaveAnimateTypeHide,
};

@interface TTWaterWaveView : UIView

@property (nonatomic, strong) UIColor *firstWaveColor;
@property (nonatomic, strong) UIColor *secondWaveColor;
@property (nonatomic, assign) CGFloat percent;            // the maximum percentage of rise height

/*
 Build waves and start high tide show animation
 */
- (void)startWave;

/*
 Delete waves after the hide animation
 */
- (void)stopWave;

/*
 Remove wave layers and stop displaylink
 */
- (void)reset;

/*
 Remove this view from superView
 */
- (void)removeFromParentView;

@end
