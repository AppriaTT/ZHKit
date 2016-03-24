//
//  UITabBar+badgeView.h
//  LinkHere(R)
//
//  Created by arron on 16/3/24.
//  Copyright © 2016年 LinkHere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badgeView)
/**
 *  自定义显示小红点提示
 *
 *  @param index  第几个buttonItem/
 *  @param number 数字多少, nil为消失
 */
- (void)showBadgeOnItemIndex:(NSInteger)index WithNumber:(NSString *)number;
@end
