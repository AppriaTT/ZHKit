//
//  ZHNewsDetailReadController.h
//  足球控(DIY)
//
//  Created by qianfeng on 16/1/10.
//  Copyright (c) 2016年 叶无道. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *这是一个专门用来加载webView的带 进度条 的控制器 传入一个url即可
 */
@interface ZHWebViewController : UIViewController
/**
 *  此为传入的url, 用 setUrlString 传入
 */
@property (nonatomic ,copy) NSString *urlString;

/**
 *  @param urlString URL字符串
 *
 *  @return 直接返回一个controller
 */
+(instancetype)controllerWithUrl:(NSString *)urlString;
@end
