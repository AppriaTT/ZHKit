//
//  ZHBottomView.h
//  DIYNavigationController
//
//  Created by YZH on 15/12/9.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBottomView;
@protocol ZHBottomViewDelegate <NSObject>
@optional
- (void)bottomViewItemsDidClicked :(ZHBottomView*)view andButton:(UIButton *)button;
@end

@interface ZHBottomView : UIView
@property(nonatomic,copy)NSArray * items;
@property (nonatomic,weak)  id<ZHBottomViewDelegate> delegate;
+ (instancetype)bottomView;
@end
