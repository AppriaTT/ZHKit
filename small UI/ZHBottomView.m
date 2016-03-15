//
//  ZHBottomView.m
//  DIYNavigationController
//
//  Created by YZH on 15/12/9.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "ZHBottomView.h"

@implementation ZHBottomView
+ (instancetype)bottomView
{
    return [[self alloc]init];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}
- (void)setItems:(NSArray *)items
{
    //1.set方法一定要先保存全局变量
    _items = items;
    

    for(int i = 0; i < items.count;i++)
    {
        //1.取出每一个UIbutton对象
        UIButton * btn = items[i];
        //2.建立父子关系
        [self addSubview:btn];
        //3.设置正确的Frame值
        CGFloat btnW = self.frame.size.width / items.count;
        CGFloat btnH = self.frame.size.height;
        CGFloat btnX = i * btnW;
        CGFloat btnY = 0;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        //4.添加监听事件
        [btn addTarget:self action:@selector(btnTouch:) forControlEvents:UIControlEventTouchUpInside];
        //5.添加临时的tag标记
        btn.tag = i;
        
    }//end for
    
    
//    [self btnTouch:items[0]];
    
}
//这个方法是系统自己主动调用,并且调用的时候,会把父亲控件对象作为参数传递进来
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGFloat tabViewW = newSuperview.frame.size.width;//self.view.frame.size.width; //总是与屏幕的宽度完全相同
    CGFloat tabViewH = 60;
    CGFloat tabViewX = 0;
    CGFloat tabViewY = newSuperview.frame.size.height - tabViewH;//self.view.frame.size.height - tabViewH;
    //    tabView.frame = CGRectMake(tabViewX, tabViewY, tabViewW, tabViewH);
    self.frame = CGRectMake(tabViewX, tabViewY, tabViewW, tabViewH);
    self.backgroundColor = [UIColor yellowColor];
    
}
- (void)btnTouch:(UIButton *)button
{
    for(UIButton * button in self.items)
    {
        button.selected = NO;
        //控件是否接受,用户的交互事件
        button.userInteractionEnabled = YES;
    }
    
    button.selected = YES;
    
    [self.delegate bottomViewItemsDidClicked:self andButton:button];
    button.userInteractionEnabled = NO;
}
@end
