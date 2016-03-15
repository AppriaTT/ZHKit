//
//  ZHSharpedView.h
//  可变图像
//
//  Created by Aaron on 1/19/16.
//  Copyright © 2016 AppariTT. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  这是一个梯形的imageView
 */

@interface ZHShapedImageView : UIImageView
/**
 *  可以创建一个梯形的imageView;
 *  @param p     这表示的是 0上1中2下
 */
- (instancetype)initWithFrame:(CGRect)frame andPosition:(NSInteger)p;
@end
