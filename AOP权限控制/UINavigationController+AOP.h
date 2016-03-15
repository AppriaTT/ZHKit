//
//  UINavigationController+AOP.h
//  02-apoUI应用
//
//  Created by 哲 肖 on 15/12/23.
//  Copyright (c) 2015年 肖喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (AOP)

//权限控制交换push方法, 将需要权限控制的控制器放在auth.plist文件中
-(void)aop_pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
