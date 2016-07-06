//
//  ZHLabel.m
//
//  Created by Aaron on 16/7/4.
//  Copyright © 2016年 muhu. All rights reserved.
//

#import "ZHLabel.h"
#import <CoreText/CoreText.h>
NSString *const kZHLabelTextAttributed = @"ZHLabelTextAttributed";


@implementation ZHLabel
{
    CTFrameRef _stringCTFrame;
    NSInteger _length ;
    NSMutableArray *_modelA;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _modelA = [NSMutableArray array];
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    /*
     coreText 起初是为OSX设计的，而OSX得坐标原点是左下角，y轴正方向朝上。iOS中坐标原点是左上角，y轴正方向向下。
     若不进行坐标转换，则文字从下开始，还是倒着的
     正如之上的背景说的，coreText使用的是系统坐标，然而我们平时所接触的iOS的都是屏幕坐标，所以要将屏幕坐标系转换系统坐标系，这样才能与我们想想的坐标互相对应。
     */
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);//设置字形的变换矩阵为不做图形变换
    CGContextTranslateCTM(context, 0, self.bounds.size.height);//平移方法，将画布向上平移一个屏幕高
    CGContextScaleCTM(context, 1.0, -1.0);//缩放方法，x轴缩放系数为1，则不变，y轴缩放系数为-1，则相当于以x轴为轴旋转180度
    
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];

    //一个frame的工厂，负责生成frame
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeStr);
    //创建绘制区域
    CGMutablePathRef path = CGPathCreateMutable();
    //添加绘制尺寸
    CGPathAddRect(path, NULL, self.bounds);
    NSInteger length = attributeStr.length;
    //工厂根据绘制区域及富文本（可选范围，多次设置）设置frame
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, length), path, NULL);
    //根据frame绘制文字

    
    _length = length;
    _stringCTFrame = frame;
    
    CTFrameDraw(frame, context);

//    CFRelease(path);
//    CFRelease(frameSetter);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint location = [self systemPointFromScreenPoint:[touch locationInView:self]];

    [self ClickOnStrWithPoint:location];
}

///字符串点击检查
/*
 实际上接受所有非图片的点击事件，将字符串的每个
 字符取出与点击位置比较，若在范围内则点击到文字
 ，进而检测对应的文字是否响应事件，若存在响应
 */
-(void)ClickOnStrWithPoint:(CGPoint)location
{
    NSArray * lines = (NSArray *)CTFrameGetLines(_stringCTFrame);//self.data.ctFrame);
    CFRange ranges[lines.count];
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(_stringCTFrame, CFRangeMake(0, 0), origins);//_frame
    for (int i = 0; i < lines.count; i ++) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        CFRange range = CTLineGetStringRange(line);
        ranges[i] = range;
    }
    for (int i = 0; i < _length; i ++) {
        long maxLoc;
        int lineNum;
        for (int j = 0; j < lines.count; j ++) {
            CFRange range = ranges[j];
            maxLoc = range.location + range.length - 1;
            if (i <= maxLoc) {
                lineNum = j;
                break;
            }
        }
        CTLineRef line = (__bridge CTLineRef)lines[lineNum];
        CGPoint origin = origins[lineNum];
        CGRect CTRunFrame = [self frameForCTRunWithIndex:i CTLine:line origin:origin];
        
        if ([self isFrame:CTRunFrame containsPoint:location]) {
            //判断是否需要进行处理
            //传给代理, 并附带参数
            NSDictionary *dict = [self.attributedText attributesAtIndex:i effectiveRange:nil]; //可以优化一下
            if (dict[kZHLabelTextAttributed]) {
                MHLog(@"%@",dict);
                if ([self.delegate respondsToSelector:@selector(ZHLabel:HighlightedTitleDidClickedWithDict:)]) {
                    [self.delegate ZHLabel:self HighlightedTitleDidClickedWithDict:dict];
                }
            }else{
                 NSLog(@"您点击到了第 %d 个字符，位于第 %d 行，然而他没有响应事件。",i,lineNum + 1);//点击到文字，然而没有响应的处理。可以做其他处理
            }
            
            
            
            
            return;
        }
    }
    NSLog(@"您没有点击到文字");
}


-(CGPoint)systemPointFromScreenPoint:(CGPoint)origin
{
    return CGPointMake(origin.x, self.bounds.size.height - origin.y);
}

-(BOOL)isFrame:(CGRect)frame containsPoint:(CGPoint)point
{
    return CGRectContainsPoint(frame, point);
}

-(CGRect)frameForCTRunWithIndex:(NSInteger)index
                         CTLine:(CTLineRef)line
                         origin:(CGPoint)origin
{
    CGFloat offsetX = CTLineGetOffsetForStringIndex(line, index, NULL);
    CGFloat offsexX2 = CTLineGetOffsetForStringIndex(line, index + 1, NULL);
    offsetX += origin.x;
    offsexX2 += origin.x;
    CGFloat offsetY = origin.y;
    CGFloat lineAscent;
    CGFloat lineDescent;
    NSArray * runs = (__bridge NSArray *)CTLineGetGlyphRuns(line);
    CTRunRef runCurrent;
    for (int k = 0; k < runs.count; k ++) {
        CTRunRef run = (__bridge CTRunRef)runs[k];
        CFRange range = CTRunGetStringRange(run);
        NSRange rangeOC = NSMakeRange(range.location, range.length);
        if ([self isIndex:index inRange:rangeOC]) {
            runCurrent = run;
            break;
        }
    }
    CTRunGetTypographicBounds(runCurrent, CFRangeMake(0, 0), &lineAscent, &lineDescent, NULL);
    CGFloat height = lineAscent + lineDescent;
    return CGRectMake(offsetX, offsetY, offsexX2 - offsetX, height);
}

-(BOOL)isIndex:(NSInteger)index inRange:(NSRange)range
{
    if ((index <= range.location + range.length - 1) && (index >= range.location)) {
        return YES;
    }
    return NO;
}


@end
