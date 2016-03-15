

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoPlayViewDelegate <NSObject>

@optional
- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

- (void)videoplayViewWillExitPlay;
@end

@interface ZHVideoPlayView : UIView

+ (instancetype)videoPlayView;

@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;

@property (nonatomic, strong) AVPlayerItem *playerItem;


/**
 *  设置播放时间的接口
 */
- (void)setPlayPeriodWithStartTime:(NSTimeInterval)time;
@end
