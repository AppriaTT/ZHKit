//
//  UINavigationController+AOP.m
//  02-apoUI应用
//
//  Created by 哲 肖 on 15/12/23.
//  Copyright (c) 2015年 肖喆. All rights reserved.
//

#import "UINavigationController+AOP.h"
#import "NSObject+AOP.h"
#import "GPLoginViewController.h"

@implementation UINavigationController (AOP)
/*
 
 Aop: 是面向切面编程
 //就是在不需要改变源代码逻辑的前提下,增加一些逻辑进去,并且这个逻辑是在整个程序的生命周期之内都能够应用
 
 */

//系统会在所有方法执行之前调用load方法,并且只会调用一次
//我们可在load方法中,编写一些只需要执行一次的配置相关逻辑
+(void)load
{
    
    [UINavigationController aop_changeMethod:@selector(pushViewController:animated:) newMethod:@selector(aop_pushViewController:animated:)];
    NSLog(@"load");
}

-(void)aop_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //1.在执行真正的push之前添加一些其他逻辑
    NSLog(@"push 执行之前执行一些列代码");
    
    //1.进行权限判断,如果已经登录的用户可以随意push任何页面
    
    if(self.viewControllers.count > 0){
    
        NSUserDefaults * df = [NSUserDefaults standardUserDefaults];
        
        //取出偏好设置里的名字和密码进行验证......
        NSString * name = [df objectForKey:@"name"];
//        NSString * 
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"auth.plist" ofType:nil];
        
        NSArray * tmp = [NSArray arrayWithContentsOfFile:path];//@[@"GPTwoDetailViewController",@"GPOneDetailViewController"];
        
        for(NSString * className in tmp)
        {
            
            if([className isEqualToString:NSStringFromClass([viewController class])])
            {
                if(name == nil || name.length < 6)
                {
                    
                    GPLoginViewController * loginView = [[GPLoginViewController alloc] init];
                    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:loginView];
                    [self presentViewController:nav animated:YES completion:nil];
                    
                    return;
                    
                }
            }
            
        }
    }//end if (self.viewControllers.count > 0)
    
    //2.没有登录的就跳入登录页面
    
    
    [self aop_pushViewController:viewController animated:animated];
    
    //2.在原逻辑执行之后,添加一些逻辑代码
    NSLog(@"push 执行之后执行一些列代码");
}

@end
