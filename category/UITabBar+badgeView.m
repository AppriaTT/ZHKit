//
//  UITabBar+badgeView.m
//  LinkHere(R)
//
//  Created by arron on 16/3/24.
//  Copyright © 2016年 LinkHere. All rights reserved.
//

#import "UITabBar+badgeView.h"
//#import <objc/runtime.h>
@implementation UITabBar (badgeView)
- (void)showBadgeOnItemIndex:(NSInteger)index WithNumber:(NSString *)number
{
    //如果为空则隐藏小红点
    if (!number) {
        [self hideBadgeOnItemIndex:index];
        return;
    }
    UILabel *badgeViewL = (id)[self viewWithTag:272 + index];
    //不存在就创建
    if (!badgeViewL) {
        badgeViewL = [self newBadgeViewOnItemIndex:index];
        badgeViewL.text = number;
    }else
    {
        badgeViewL.hidden = NO;
        badgeViewL.text = number;
    }
}

//新建小红点
- (UILabel *)newBadgeViewOnItemIndex:(NSInteger)index
{
    //新建小红点
    UILabel *badgeViewL = [[UILabel alloc]init];
    badgeViewL.textAlignment = NSTextAlignmentCenter;
    badgeViewL.font = [UIFont systemFontOfSize:11];
    badgeViewL.textColor = [UIColor whiteColor];
    badgeViewL.layer.masksToBounds = YES;
    badgeViewL.tag = 272 + index;
    badgeViewL.layer.cornerRadius = 10;//圆形
    badgeViewL.backgroundColor = [UIColor redColor];//颜色：红色
    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
    float percentX = (index +0.55) / tabbarButtonNumber;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeViewL.frame = CGRectMake(x, y, 20, 20);//圆形大小为20
    [self addSubview:badgeViewL];
    return badgeViewL;
}

//隐藏小红点
- (void)hideBadgeOnItemIndex:(NSInteger)index{
    UILabel *badgeViewL = (id)[self viewWithTag:272 + index];
    badgeViewL.hidden = YES;
}
@end
