//
//  ZHSharpedView.m
//  可变图像
//
//  Created by Aaron on 1/19/16.
//  Copyright © 2016 AppariTT. All rights reserved.
//

#import "ZHShapedImageView.h"


#define margin 15
@interface ZHShapedImageView()
{
    CALayer      *_contentLayer;
    CAShapeLayer *_maskLayer;
    /**
     * 记录上中下的成员变量
     */
    NSInteger _p;
}
@end

@implementation ZHShapedImageView

- (instancetype)initWithFrame:(CGRect)frame andPosition:(NSInteger)p
{
    _p = p;
    self = [super initWithFrame:frame];
    if (self) {
        switch (_p) {
            case 0:
                [self setup1];
                break;
            case 1:
                [self setup2];
                break;
            case 2:
                [self setup3];
                break;
            default:
                break;
        }
    }
    return self;
}
//第二块
- (void)setup2
{
    //设置梯形路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint origin = self.bounds.origin;
    
    CGPathMoveToPoint(path, NULL, origin.x + self.bounds.size.width, origin.y + margin);
    
    CGPathAddLineToPoint(path, NULL, origin.x + self.bounds.size.width, self.bounds.size.height - margin);
    
    CGPathAddLineToPoint(path, NULL, origin.x,self.bounds.size.height);
    
    CGPathAddLineToPoint(path, NULL, origin.x, origin.y);
    
    CGPathCloseSubpath(path);
    
    _maskLayer = [CAShapeLayer layer];
    
    _maskLayer.path = path;
    
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];
    
}
//第1块
- (void)setup1
{
    //设置梯形路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint origin = self.bounds.origin;
    
    CGPathMoveToPoint(path, NULL, origin.x + self.bounds.size.width, origin.y);
    
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height);
    
    CGPathAddLineToPoint(path, NULL, origin.x,self.bounds.size.height - margin);
    
    CGPathAddLineToPoint(path, NULL, origin.x, origin.y);
    
    CGPathCloseSubpath(path);
    
    _maskLayer = [CAShapeLayer layer];
    
    _maskLayer.path = path;
    
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];
    
}
//第三块
- (void)setup3
{
    //设置梯形路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint origin = self.bounds.origin;
    
    CGPathMoveToPoint(path, NULL, origin.x + self.bounds.size.width, origin.y);
    
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height);
    
    CGPathAddLineToPoint(path, NULL, origin.x,self.bounds.size.height);
    
    CGPathAddLineToPoint(path, NULL, origin.x, origin.y + margin);
    
    CGPathCloseSubpath(path);
    
    _maskLayer = [CAShapeLayer layer];
    
    _maskLayer.path = path;
    
    _maskLayer.fillColor = [UIColor blackColor].CGColor;
    _maskLayer.strokeColor = [UIColor redColor].CGColor;
    _maskLayer.frame = self.bounds;
    
    _maskLayer.contentsScale = [UIScreen mainScreen].scale;
    _contentLayer = [CALayer layer];
    _contentLayer.mask = _maskLayer;
    _contentLayer.frame = self.bounds;
    [self.layer addSublayer:_contentLayer];
    
}

- (void)setImage:(UIImage *)image
{
    _contentLayer.contents = (id)image.CGImage;
}

@end
