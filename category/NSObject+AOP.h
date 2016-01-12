//
//  NSObject+AOP.h
//  AOP black magic
//
//  Created by qianfeng on 15/12/23.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (AOP)
/**
 *  可以转换两个方法的实现内容
 *
 *  @param oldMethod 旧方法
 *  @param newMethod 新方法
 */
+(void)aop_changeMethod:(SEL)oldMethod newMethod:(SEL)newMethod;
@end

@interface UITabBarItem (UIImage)
/**
 *  使图片不渲染的系统方法转向
 */
- (void)my_setImage:(UIImage *)image;
/**
 *  使图片不渲染的系统方法转向
 */
-(void)my_setSelectedImage:(UIImage *)selectedImage;
@end