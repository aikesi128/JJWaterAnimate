//
//  ViewController.m
//  JJWaterAnimate
//
//  Created by x on 17/7/21.
//  Copyright © 2017年 cesiumai. All rights reserved.
//

#import "ViewController.h"

#import "TTWaterWaveView.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    TTWaterWaveView *view = [[TTWaterWaveView alloc]initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 200)];
    
    view.percent = 0.66;

    view.firstWaveColor = [UIColor blueColor];
    
    view.secondWaveColor = [UIColor blackColor];
    
    [self.view addSubview:view];
    
    [view startWave];

}



@end
