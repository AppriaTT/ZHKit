//
//  ZHLabel.h
//
//  Created by Aaron on 16/7/4.
//  Copyright © 2016年 muhu. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kZHLabelTextAttributed;

@class ZHLabel;
@protocol ZHLabelDelegate<NSObject>
@optional
- (void)ZHLabel:(ZHLabel *)label HighlightedTitleDidClickedWithDict:(NSDictionary *)params;

@end

typedef NS_ENUM(NSInteger,ZHLabelTextAttributed){
    ZHLabelTextAttributedHighlighted = 1
};

@interface ZHLabel : UIView
/**
 *  添加属性 kZHLabelTextAttributed 为 ZHLabelTextAttributedHighlighted 则为高亮可点击, 并将参数加在属性字典中
 */
@property (nonatomic,strong)NSAttributedString *attributedText;

@property (nonatomic,assign)id<ZHLabelDelegate>delegate;

@property (nonatomic,assign)CGFloat lableHeigh;

@end
