//
//  ZHAdvertisementSView.h
//  02-广告视图
//
//  Created by qianfeng on 15/12/15.
//  Copyright (c) 2015年 肖喆. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHAdvertisementSView;
@protocol ZHAdvertisementSViewDelegate
@optional
/**
 *  图片被点击后调用这个方法
 */
- (void)advertisementSView:(ZHAdvertisementSView *)scrollView imageViewDidClickAtIndex:(NSInteger)index;
@end

@interface ZHAdvertisementSView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,weak) id<ZHAdvertisementSViewDelegate> ZHDelegate;

/**
 *  可以设置是否添加定时器
 */
@property (nonatomic,assign,getter=isAddTimer)BOOL addTimer;
//@property (nonatomic,strong)UIPageControl *pageControl;

/**
 *  返回一个顶部的广告滚动条 默认为宽度屏幕宽度 ,高度150*ZHScale
 */
+ (instancetype)advertisementScrollVeiw;
/**
 *  添加需要滚动的图片数组
 */
- (void)addImages :(NSArray *)imageNames;

/**
 *可初始化frame
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 *  可以传入自定义view 的数组 供滚动
 */
- (void)addCustomViewArray:(NSArray *)viewArray;

@end
