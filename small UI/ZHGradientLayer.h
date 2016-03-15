//
//  ZHGradientView.h
//  足球控(DIY)
//
//  Created by qianfeng on 16/1/9.
//  Copyright (c) 2016年 叶无道. All rights reserved.
//

#import <UIKit/UIKit.h>
//利用layer的渐变层
@interface ZHGradientLayer : UIView
/**
 * 在参数图层上 添加一个 颜色渐变的 layer
 */
+(void)insertColorLayerWithView:(UIView *)view;
/**
 * 在参数图层上 添加一个 从左至右 透明度 由1到0 的渐变 layer
 */
+(void)insertTransparentLayerWithView:(UIView *)view;
@end
