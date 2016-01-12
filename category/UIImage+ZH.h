//
//  UIImage+ZH.h
//  ZH水印
//
//  Created by Arron on 15/11/2.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ZHColor(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define ZHRandomColor [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1.0]
@interface UIImage (ZH)
/**
 *  水印
 */
+ (instancetype) waterImageWithBg :(NSString *)path andLogo :(NSString *)logo;

/**
 *  白边框头像
 */
+ (instancetype) circleImageWithName :(NSString *)name andBorderWidth :(NSUInteger)width andColor:(UIColor *)color;

/**
 *  截图
 */
+ (instancetype)captureWithView:(UIView *)view;

/**
 *  返回一张可拉伸的图片
 */
+ (UIImage *) resizableImage:(NSString *)name;
/**
 *  返回一张纯色的图
 */
+ (UIImage *) colorfulPicture :(UIColor *)color withSize:(CGSize)size;
@end
