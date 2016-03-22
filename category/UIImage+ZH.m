//
//  UIImage+ZH.m
//  ZH水印
//
//  Created by Arron on 15/11/2.
//  Copyright (c) 2015年 叶无道. All rights reserved.
//

#import "UIImage+ZH.h"

@implementation UIImage (ZH)
//水印
+ (instancetype) waterImageWithBg :(NSString *)bg andLogo :(NSString *)logo
{
    UIImage *bgImage = [UIImage imageNamed:bg];
    //创建一个基于位图的上下文(背景的尺寸，是否不透明，拉伸尺寸)，将水印放在上面
    UIGraphicsBeginImageContextWithOptions(bgImage.size,NO, 0.0);
    
    //将背景画出来
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    //画出右下角水印
    UIImage *waterImage = [UIImage imageNamed:logo];
    CGFloat scale = 0.2;//水印缩放比例
    CGFloat waterW = waterImage.size.width*scale;
    CGFloat waterH = waterImage.size.height*scale;
    CGFloat margin = 5;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    //从上下文中取得制作完毕的UIIMAGE对象
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

//白色边框圆头像
+ (instancetype) circleImageWithName :(NSString *)name andBorderWidth :(NSUInteger)borderWidth andColor:(UIColor *)color
{
    //加载图片
    UIImage *img = [UIImage imageNamed:name];
    //开启上下文
    CGFloat imgW = img.size.width + 2 * borderWidth;
    CGFloat imgH = img.size.height + 2 * borderWidth;
    CGSize imgSize = CGSizeMake(imgW, imgH);
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //画大圆
    [color set];
    //    [[UIColor whiteColor] setFill];
    
    CGFloat bigRadius = imgW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI*2, 0);
    CGContextFillPath(ctx);
    
    //画小圆
    //    [[UIColor blackColor] set];
    CGFloat smallRadius = img.size.width * 0.5;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI*2, 0);
    //剪裁
    CGContextClip(ctx);//后面添加的东西才会受裁剪的影响
    
    //画图进裁剪过的圆
    [img drawInRect:CGRectMake(borderWidth, borderWidth, img.size.width, img.size.height)];
    
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}

//截图
+(instancetype)captureWithView:(UIView *)view {
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    //渲染
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //取出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext()  ;
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *) resizableImage:(NSString *)name
{
    UIImage *img = [UIImage imageNamed:name];
    CGFloat h =img.size.height*0.5;
    CGFloat w =img.size.width*0.5;
    //拉伸图片 并平铺内部一定范围内的像素
    return [img resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

+ (UIImage *) colorfulPicture :(UIColor *)color withSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, 0.0);
    [color set];//设置颜色
    //画框
    UIRectFill(CGRectMake(0, 0, 50 , 50));
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


//使二维码变得清晰
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
@end
