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
        
        //new
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelBeTapped:)];
        [self addGestureRecognizer:tapGesture];
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

#pragma mark new
- (void)labelBeTapped:(UIGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        CGPoint pt = [tap locationInView:self];
        
        //传给代理, 并附带参数
        NSDictionary *dict = [self textAttributesAtPoint:pt];
        
        if (dict[kZHLabelTextAttributed]) {
            MHLog(@"%@",dict);
            if ([self.delegate respondsToSelector:@selector(ZHLabel:HighlightedTitleDidClickedWithDict:)]) {
                [self.delegate ZHLabel:self HighlightedTitleDidClickedWithDict:dict];
            }
        }
    }
    
}

//寻找点击处的属性字典
-(NSDictionary*)textAttributesAtPoint:(CGPoint)pt
{
    // Locate the attributes of the text within the label at the specified point
    NSDictionary* dictionary = nil;
    
    // First, create a CoreText framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedText);
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    // Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);
    
    // Get each of the typeset lines
    NSArray *lines = (__bridge id)CTFrameGetLines(frameRef);
    
    CFIndex linesCount = [lines count];
    CGPoint *lineOrigins = (CGPoint *) malloc(sizeof(CGPoint) * linesCount);
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0, linesCount), lineOrigins);
    
    CTLineRef line = NULL;
    CGPoint lineOrigin = CGPointZero;
    
    // Correct each of the typeset lines (which have origin (0,0)) to the correct orientation (typesetting offsets from the bottom of the frame)
    
    CGFloat bottom = self.frame.size.height;
    for(CFIndex i = 0; i < linesCount; ++i) {
        lineOrigins[i].y = self.frame.size.height - lineOrigins[i].y;
        bottom = lineOrigins[i].y;
    }
    
    // Offset the touch point by the amount of space between the top of the label frame and the text
    pt.y -= (self.frame.size.height - bottom)/2;
    
    
    // Scan through each line to find the line containing the touch point y position
    for(CFIndex i = 0; i < linesCount; ++i) {
        line = (__bridge CTLineRef)[lines objectAtIndex:i];
        lineOrigin = lineOrigins[i];
        CGFloat descent, ascent;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, nil);
        
        if(pt.y < (floor(lineOrigin.y) + floor(descent))) {
            
            // Cater for text alignment set in the label itself (not in the attributed string)
            if (self.textAlignment == NSTextAlignmentCenter) {
                pt.x -= (self.frame.size.width - width)/2;
            } else if (self.textAlignment == NSTextAlignmentRight) {
                pt.x -= (self.frame.size.width - width);
            }
            
            // Offset the touch position by the actual typeset line origin. pt is now the correct touch position with the line bounds
            pt.x -= lineOrigin.x;
            pt.y -= lineOrigin.y;
            
            // Find the text index within this line for the touch position
            CFIndex i = CTLineGetStringIndexForPosition(line, pt);
            
            // Iterate through each of the glyph runs to find the run containing the character index
            NSArray* glyphRuns = (__bridge id)CTLineGetGlyphRuns(line);
            CFIndex runCount = [glyphRuns count];
            for (CFIndex run=0; run<runCount; run++) {
                CTRunRef glyphRun = (__bridge CTRunRef)[glyphRuns objectAtIndex:run];
                CFRange range = CTRunGetStringRange(glyphRun);
                if (i >= range.location && i<= range.location+range.length) {
                    dictionary = (__bridge NSDictionary*)CTRunGetAttributes(glyphRun);
                    break;
                }
            }
            if (dictionary) {
                break;
            }
        }
    }
    
    free(lineOrigins);
    CFRelease(frameRef);
    CFRelease(framesetter);
    
    
    return dictionary;
}

@end
