//
//  NSObject+AOP.m
//  AOP black magic
//
//  Created by qianfeng on 15/12/23.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "NSObject+AOP.h"
#import <objc/runtime.h>


@implementation NSObject (AOP)
+(void)aop_changeMethod:(SEL)oldMethod newMethod:(SEL)newMethod
{
    Method oldM = class_getInstanceMethod([self class], oldMethod);
    Method newM = class_getInstanceMethod([self class], newMethod);
    method_exchangeImplementations(oldM, newM);
}

@end
@implementation UITabBarItem (UIImage)
+(void)load
{
    [UITabBarItem aop_changeMethod:@selector(setImage:) newMethod:@selector(my_setImage:)];
    [UITabBarItem aop_changeMethod:@selector(setSelectedImage:) newMethod:@selector(my_setSelectedImage:)];

}
- (void)my_setImage:(UIImage *)image
{
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self my_setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//交换之后再掉用系统的方法
}
-(void)my_setSelectedImage:(UIImage *)selectedImage
{
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self my_setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

@end
