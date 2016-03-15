//
//  ZHNewFeatureSCView.m
//
//  Created by YZH on 15/12/15.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "ZHNewFeatureSCView.h"
#import "UIView+Extension.h"
@implementation ZHNewFeatureSCView
+(instancetype)newFeatureView
{
    return [[self alloc]initWithFrame:[UIScreen mainScreen].bounds];
}

+(instancetype)newFeatureViewWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.contentSize = self.frame.size;
    }
    return self;
}

-(void)setPicNameArray:(NSArray *)picNameArray
{
    _picNameArray = picNameArray;
    NSInteger picNum = picNameArray.count;
    //设置内容大小
    self.contentSize = CGSizeMake(self.width * picNum, self.height);
    
    for (int i = 0; i < picNum; i++) {
        //图片
        NSString *name = [NSString stringWithString:picNameArray[i]];
        UIImage *img = [UIImage imageNamed:name];
        
        UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
        imgView.centerX = self.centerX;
        imgView.centerY = self.centerY;

        imgView.frame = CGRectMake(self.width * i , self.y, self.width, self.height);
        [self addSubview:imgView];
        
        //设置最后一张的按钮
        if (i == picNum - 1) {
            imgView.userInteractionEnabled = YES;
            [self setupStartBtn:imgView];
        }
        
    }
    
}


//设置开始按钮
-(void)setupStartBtn:(UIImageView *)imgView
{
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        startBtn.backgroundColor = [UIColor redColor];
    [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.size = CGSizeMake(100, 44);
    startBtn.centerX = self.width * 0.5;
    startBtn.centerY = self.height * 0.8;
    
    [imgView addSubview:startBtn];
}


- (void)startClick:(UIButton *)button
{
    
    [self.ZHDelegate ZHNewFeatureSCViewStartButtonDidClicked:self button:button];
    NSLog(@"startClick");
}
@end
