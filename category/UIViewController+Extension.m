//
//  UIViewController+Extension.m
//  day5作业
//
//  Created by qianfeng on 15/12/14.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>
@interface UIViewController()
@property (nonatomic,assign)BOOL expand;

@end
@implementation UIViewController (Extension)

const char key;

-(void)setExpand:(BOOL)expand
{
    objc_setAssociatedObject(self, &key, @(expand), OBJC_ASSOCIATION_ASSIGN);
    
}
-(BOOL)expand
{
    return [objc_getAssociatedObject(self, &key) boolValue];
}

-(void)open
{
    if ((self.expand = !self.expand)) {
        
        self.view.transform = CGAffineTransformMakeTranslation(250, 0);
        
    }else{
        
        self.view.transform = CGAffineTransformIdentity;
    }
}
@end
