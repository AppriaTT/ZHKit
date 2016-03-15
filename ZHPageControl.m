//
//  ZHPageControl.m
//  DIYPageControl
//
//  Created by YZH on 15/12/15.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "ZHPageControl.h"
#import "UIView+Extension.h"
#define pageX 12
@implementation ZHPageControl
{
    NSArray *_btnsArray;
}
+(instancetype)pageControl
{
    CGFloat SW = [UIScreen mainScreen].bounds.size.width;
    return [[self alloc]initWithFrame:CGRectMake(0, 0, SW, 20)];
}

+(instancetype)pageControlWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        //默认button为1
        _position = ZHPageControlPositionBottomCenter;
        self.numberOfPages = 1;
        //当前页
        _currentPage = 1;
    }
    return self;
}
//重写数量的set方法
-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    //移除之前的所有页码进行重行设置
    for (UIButton *btn in _btnsArray) {
        [btn removeFromSuperview];
    }
    
    _numberOfPages = numberOfPages;
    //添加buttons
    NSMutableArray *btnM = [NSMutableArray array];
    for (int i = 0; i < numberOfPages; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        //普通状态为紫色,当前页为黄色
        if (i == 0) {
            [btn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        }
        else {
            [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        }
        btn.size = CGSizeMake(pageX, pageX);
        btn.tag = i;
        [btn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [btnM addObject:btn];
        [self addSubview:btn];
    }
    _btnsArray = btnM;
}

//重写现在页面的set方法
-(void)setCurrentPage:(NSInteger)currentPage
{
    UIButton *btnBef = _btnsArray[_currentPage - 1];
    //设置之前的颜色为紫色
    [btnBef setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    UIButton *btnLat = _btnsArray[currentPage - 1];
    //设置yellow
    [btnLat setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    _currentPage = currentPage;
}

//重写位置的set方法
- (void)setPosition:(ZHPageControlPosition)position
{
    _position = position;
    [self setNeedsLayout];
}

//每当设置number时就调用此方法
- (void)layoutSubviews
{
//    static int i = 0;
    CGFloat btnStartX ;
    
    //计算page的起始位置
    switch (self.position) {
        case 0://center
            btnStartX = (self.width - _btnsArray.count * pageX) / 2 ;
            
            break;
        case 1://left
            btnStartX = 10;
            
            break;
        case 2://right
            btnStartX = self.width - _btnsArray.count * pageX - 10;
            break;
        default:
            break;
    }
    for (int j = 0; j < _btnsArray.count; j++) {
        UIButton *btn = _btnsArray[j];
        btn.centerY = self.height * 0.5;
        btn.x = btnStartX + pageX * j;
    }
}

- (void)changePage:(UIButton *)btn
{
    self.currentPage = btn.tag + 1;
    [self.delegate ZHPageControlPageNumberDidClicked:self numberButton:btn];
}

//设置到父控件的底部
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    self.y = newSuperview.height - self.height;
}
@end
