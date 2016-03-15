//
//  ZHGradientView.m
//  足球控(DIY)
//
//  Created by qianfeng on 16/1/9.
//  Copyright (c) 2016年 叶无道. All rights reserved.
//

#import "ZHGradientLayer.h"

@implementation ZHGradientLayer
//color gradient layer
+(void)insertColorLayerWithView:(UIView *)view
{
    UIColor *colorOne = [UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = view.bounds;
    
    [view.layer insertSublayer:headerLayer above:0];
}

+(void)insertTransparentLayerWithView:(UIView *)view
{
    //设置颜色及透明度渐变 one为初始,two为最后
    UIColor *colorOne = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(255/255.0)  green:(255/255.0)  blue:(255/255.0)  alpha:0.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = view.bounds;
    
    //设置变化的点位 0,0 为左下角, 1,1为右上角,默认从0.5,0 到0.5,1
    headerLayer.startPoint = CGPointMake(0, 0.5);
    headerLayer.endPoint = CGPointMake(1, 0.5);
    [view.layer insertSublayer:headerLayer atIndex:0];
}
@end
