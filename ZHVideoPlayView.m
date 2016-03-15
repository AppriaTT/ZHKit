
#import "ZHVideoPlayView.h"

@interface ZHVideoPlayView()

/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;
/**
 *  满屏按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *fullBtn;

// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
/**
 *  烹饪模式出现的view
 */
@property (weak, nonatomic) IBOutlet UIView *fullView;
@property (weak, nonatomic) IBOutlet UIView *topView;

/**
 *  开关按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/**
 *  总时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  现在的时间
 */
@property (weak, nonatomic) IBOutlet UILabel *currentTime;

// 记录当前是否显示了工具栏
@property (assign, nonatomic) BOOL isShowToolView;

/* 定时器 */
@property (nonatomic, strong) NSTimer *progressTimer;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;

#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)sliderValueChange;

@end

@implementation ZHVideoPlayView
// 快速创建View的方法
+ (instancetype)videoPlayView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZHVideoPlayView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    //添加AVPlayer
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.imageView.layer addSublayer:self.playerLayer];
    //初始化隐藏工具栏
    self.isShowToolView = YES;

    [self removeProgressTimer];
    [self addProgressTimer];
    
    self.playOrPauseBtn.selected = YES;
    //进入时全屏view隐藏
    self.fullView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
//视频item传入就进行播放
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
}

// 是否显示工具的View
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.hidden = 1;
            self.topView.hidden = 1;
            self.fullView.hidden = 1;
            self.isShowToolView = NO;
        } else {
            self.toolView.hidden = 0;
            self.topView.hidden = 0;
            
            self.isShowToolView = YES;
        }
    }];
}
// 暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        
        [self addProgressTimer];
    } else {
        [self.player pause];
        
        [self removeProgressTimer];
    }
}

//重新播放点击
- (IBAction)replayClick:(id)sender {
    //重新回到00:00
    [self setPlayPeriodWithStartTime:0];
}
//外部设置播放的时间
- (void)setPlayPeriodWithStartTime:(NSTimeInterval)time
{
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
}
#pragma mark - 定时器操作
- (void)addProgressTimer
{
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo
{
    // 1.更新现在时间
    self.currentTime.text = [self timeString];
    
    
        // 2.设置进度条的value
        self.progressView.progress = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    
    CMTime time = self.player.currentItem.duration ;
    if (time.value != NULL) {
    // 3.更新剩余时间
        self.timeLabel.text = [self stringWithCurrentTime:CMTimeGetSeconds(self.playerItem.duration)-CMTimeGetSeconds(self.playerItem.currentTime)];
    }
}

- (NSString *)timeString
{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    
    return [self stringWithCurrentTime:currentTime];
}



- (IBAction)startSlider {
    [self removeProgressTimer];
}


- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime
{
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@", currentString];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
#pragma mark 转换模式
//进入烹饪模式
- (IBAction)pengrenModel:(UIButton *)sender {
    sender.selected = YES;
    //判断是否经过了变换 如果不满屏 则进行变换操作
    if (!self.fullBtn.selected) {
        if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
            [self.delegate videoplayViewSwitchOrientation:self.fullBtn.selected = !self.fullBtn.selected];
        }
    }//否则
    //让烹饪view显示出来
    self.fullView.hidden = NO;
    //隐藏其余的工具栏
    self.topView.hidden = YES;
    self.toolView.hidden = YES;
    //移除手势
    [self removeGestureRecognizer:self.tap];
    
}

//退出烹饪模式
- (IBAction)exitPengRenModel:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
        [self.delegate videoplayViewSwitchOrientation:NO];
    }
    //重新加入手势
    [self addGestureRecognizer:self.tap];
    //显示工具栏
    self.topView.hidden = NO;
    self.toolView.hidden = NO;
    //隐藏烹饪面板
    self.fullView.hidden = YES;
    //让全屏按钮取消选中
    self.fullBtn.selected = !self.fullBtn.selected;
}


// 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
        [self.delegate videoplayViewSwitchOrientation:sender.selected];
    }
}

//退出播放
- (IBAction)exitPlay:(id)sender {

    if ([self.delegate respondsToSelector:@selector(videoplayViewWillExitPlay)]) {
        [self.delegate videoplayViewWillExitPlay];
    }
}


@end


