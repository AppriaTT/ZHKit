//
//  UIBarButtonItem+Extension.m
//  微博
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
+(UIBarButtonItem *)barButtonItemWithNormalImageName :(NSString *)norImg highlitedImageName:(NSString *)higImg andTarget:(id)target action:(SEL)action
{

    UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:norImg] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:higImg] forState:UIControlStateHighlighted];
//    btn.size = btn.currentBackgroundImage.size;
    btn.size = CGSizeMake(30, 30);
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[self alloc]initWithCustomView:btn];
    
    return item;
}
@end
