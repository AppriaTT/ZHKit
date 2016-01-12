//
//  UIView+Extension.h
//
//
//  Created by apple on 15-11-20.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZHColor(a,b,c) [UIColor colorWithRed:(a/255.0) green:(b/255.0) blue:(c/255.0) alpha:1.0]
#define ZHRColor [UIColor colorWithRed:(arc4random()%256/255.0) green:(arc4random()%256/255.0) blue:(arc4random()%256/255.0) alpha:1.0]

#define ZHLog(...) NSLog(__VA_ARGS__);

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
//利用layer的渐变层
/**
 * 在参数图层上 添加一个 颜色渐变的 layer
 */
+(void)insertColorLayerWithView:(UIView *)view;
/**
 * 在参数图层上 添加一个 从左至右 透明度 由1到0 的渐变 layer
 */
+(void)insertTransparentLayerWithView:(UIView *)view;

@end
