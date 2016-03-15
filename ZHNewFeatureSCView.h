//
//  ZHNewFeatureSCView.h
//
//  Created by YZH on 15/12/15.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHNewFeatureSCView;

@protocol ZHNewFeatureSCViewDelegate <NSObject>
/**
 *  最后一页的startButton被按下时,触发的代理方法
 */
- (void)ZHNewFeatureSCViewStartButtonDidClicked:(ZHNewFeatureSCView *)scrollView button:(UIButton *)button;
@end

@interface ZHNewFeatureSCView : UIScrollView
@property (nonatomic ,copy) NSArray *picNameArray;
@property (nonatomic ,weak)id<ZHNewFeatureSCViewDelegate>ZHDelegate;

+(instancetype)newFeatureView;
+(instancetype)newFeatureViewWithFrame:(CGRect)frame;
-(void)setPicNameArray:(NSArray *)picNameArray;
@end
