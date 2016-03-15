//
//  ZHPageControl.h
//  DIYPageControl
//
//  Created by YZH on 15/12/15.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHPageControl;
typedef enum
{
    ZHPageControlPositionBottomCenter,
    ZHPageControlPositionBottomLeft,
    ZHPageControlPositionBottomRight,
}ZHPageControlPosition;
@protocol ZHPageControlDelegate <NSObject>

- (void)ZHPageControlPageNumberDidClicked:(ZHPageControl*)pageControl numberButton:(UIButton *)button;


@end
@interface ZHPageControl : UIView
/**
 *  页码的数量,默认为1
 */
@property(nonatomic,assign) NSInteger numberOfPages;

/**
 *  当前页,默认为1
 */
@property(nonatomic,assign) NSInteger currentPage;

/**
 *  设置页码的位置,默认为底部居中
 */
@property(nonatomic,assign) ZHPageControlPosition position;

@property (nonatomic,weak)  id<ZHPageControlDelegate> delegate;
+(instancetype)pageControl;
+(instancetype)pageControlWithFrame:(CGRect)frame;
-(void)setNumberOfPages:(NSInteger)numberOfPages;
-(void)setCurrentPage:(NSInteger)currentPage;
@end
