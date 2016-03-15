//
//  ZHPageSlider.m
//  shareCode
//
//  Created by qianfeng on 15/12/17.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "ZHPageSlider.h"
#import "UIView+Extension.h"
#define titleMargin _margin
#define titleBtnW 120
#define lableH 5
@implementation ZHPageSlider
{
    NSMutableArray *_titleBtnArray;
//    UILabel *_rollLable;
}
+(instancetype)pageSlider
{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, 375, 44)];
}
+(instancetype)pageSliderWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认一页
        _pageNumber = 1;
        self.selectedIndex = 0;
//        self.backgroundColor = [UIColor grayColor];
//        self.alpha = 0.7;
        self.backgroundColor = [UIColor whiteColor];
//        self.margin = titleMargin + titleBtnW;
        titleMargin = 20;//默认间距为20
    }
    return self;
}

//设置页码数目.添加控件
-(void)setPageNumber:(NSUInteger)pageNumber
{
        _pageNumber  = pageNumber;
        //判断长短
        CGFloat W = self.width < (titleBtnW + titleMargin) * pageNumber? (titleBtnW + titleMargin) * pageNumber:self.width;
        if (W == self.width) {
            _margin = (self.width - titleBtnW * pageNumber) / (pageNumber + 1);
        }
        self.contentSize = CGSizeMake(W, self.height);
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceHorizontal = YES;
        //移除
        [self removeSubviews];
        for (int i = 0; i < pageNumber; i++) {
            //添加按钮
            UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [titleBtn setTitle:self.titleArray[i] forState:UIControlStateNormal];
            [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            titleBtn.width = titleBtnW;
            titleBtn.height = self.height - 10;
            titleBtn.tag = i;
//            titleBtn.backgroundColor = [UIColor redColor];
            
            titleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleBtn];
            //将按钮添加进数组
            [_titleBtnArray addObject:titleBtn];
        }
        //添加滚动的lable
        UILabel *rollLable =[[UILabel alloc]init];
        _rollLable = rollLable;
        rollLable.width = titleBtnW - 10;
        rollLable.height = lableH;
        rollLable.backgroundColor = [UIColor redColor];
        [self addSubview:rollLable];
    
    [self setNeedsLayout];
}



//重置现在的index
- (void)setSelectedIndex:(NSUInteger)currentIndex
{
     [_titleBtnArray[_selectedIndex] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _selectedIndex = currentIndex;
//    //设置lable的位置
    _rollLable.centerX =titleMargin + titleBtnW * 0.5 + (titleBtnW + titleMargin) * _selectedIndex;
    [_titleBtnArray[_selectedIndex] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    int i = 0;
    for (UIButton *btn in _titleBtnArray) {
        btn.x = (titleMargin + btn.width) * i + titleMargin;
        btn.centerY = (self.height - lableH)/2;
        i++;
    }
    //设置lable的位置
    _rollLable.centerX =titleMargin + titleBtnW * 0.5 + (titleBtnW + titleMargin) * self.selectedIndex;
    _rollLable.y = self.height - _rollLable.height;
}

//删除之前的按钮
- (void)removeSubviews
{
    for (id objc in self.subviews) {
        [objc removeFromSuperview ];
    }
    _rollLable = nil;
    _titleBtnArray = [NSMutableArray array];
}


//重写标题的设置
-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    for (int i = 0; i < _titleBtnArray.count; i++) {
        UIButton *btn = _titleBtnArray[i];
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
    }
    self.pageNumber = titleArray.count;
}


//代理方法
- (void)titleBtnClick:(UIButton *)button
{
    [self.pageDelegate ZHPageSliderTitleButtonDidClicked:self atIndex:button.tag WithButton:button];
}

//titleMargin 可以进行titleMargin的重置
-(void)setMargin:(CGFloat)margin
{
    _margin = margin;
    self.pageNumber = self.pageNumber;
}
@end
