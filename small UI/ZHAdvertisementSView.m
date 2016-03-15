//
//  ZHAdvertisementSView.m
//  02-广告视图
//
//  Created by qianfeng on 15/12/15.
//  Copyright (c) 2015年 肖喆. All rights reserved.
//

#import "ZHAdvertisementSView.h"
#import "ZHRecomAPI.h"
#define  margin 5
#define ZHScale [UIScreen mainScreen].bounds.size.width / 375
@interface ZHAdvertisementSView()
@end
@implementation ZHAdvertisementSView
{
    UIPageControl *_pageControl;
    NSTimer *_timer;
    UIView *_newSuperview;
}
+ (instancetype)advertisementScrollVeiw
{
    return [[self alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150 * ZHScale)];
}

- (instancetype)initWithFrame:(CGRect)frame//代码创建
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype )initWithCoder:(NSCoder *)aDecoder//xib创建
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self setup];
    }
    return self;
}
- (void)setup
{
    //设置宽高
    //        self.frame = CGRectMake(0, 0, 375, 150);
    self.backgroundColor = [UIColor yellowColor];
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    //照片不超出
    self.layer.masksToBounds = YES;
    //加入pageControl
    UIPageControl * pageControl = [[UIPageControl alloc] init];
    
    _pageControl = pageControl;
    pageControl.frame = CGRectMake((self.frame.size.width -150 *ZHScale) / 2, self.frame.size.height - 20, 150 * ZHScale, 20);
    pageControl.numberOfPages = 3;//默认总的页数
    
    //当前页指标颜色
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    //其他页指示标颜色
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.addTimer = YES;
    
    
}
-(void)willMoveToSuperview:(UIView *)newSuperview
{
    _newSuperview = newSuperview;
}

-(void)didMoveToSuperview
{
     //把pageControl拿上来
    [_newSuperview addSubview:_pageControl];
}

//重写frame方法
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //重新计算pageControl在父视图中的位置
    _pageControl.frame = CGRectMake((self.frame.size.width -150*ZHScale) / 2, CGRectGetMaxY(self.frame) - 20, 150*ZHScale, 20);

}


- (void)addImages :(NSArray *)imageNames
{
    for(int i= 0; i < imageNames.count;i++)
    {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        //给imageView添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewClick:)];
        [imageView addGestureRecognizer:tap];
//        imageView.image = [UIImage imageNamed:imageNames[i]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageNames[i]] placeholderImage:[UIImage imageNamed:@"nopic_light"]];
        //按比例放大
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        //Frame
        CGFloat imageViewX = i * self.frame.size.width;
        CGFloat imageViewY = 0;
        CGFloat imageViewH = self.frame.size.height;
        CGFloat imageViewW = self.frame.size.width;
        imageView.frame = CGRectMake(imageViewX , imageViewY, imageViewW, imageViewH);
    }
    self.contentSize = CGSizeMake(imageNames.count * self.frame.size.width , 0);
    _pageControl.numberOfPages = imageNames.count;
    
    if (self.isAddTimer) {
        [self startTimer];
        
    }
    
}

//添加自定义视图
- (void)addCustomViewArray:(NSArray *)viewArray{
    for(int i= 0; i < viewArray.count;i++)
    {
        UIView * view = viewArray[i];
        [self addSubview:view];
        
        //Frame
        CGFloat imageViewX = i * self.frame.size.width;
        CGFloat imageViewY = 0;
        CGFloat imageViewH = self.frame.size.height;
        CGFloat imageViewW = self.frame.size.width;
        view.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    }
    self.contentSize = CGSizeMake(viewArray.count * self.frame.size.width , 0);
    _pageControl.numberOfPages = viewArray.count;
    if (self.isAddTimer) {
        [self startTimer];
    }

}

//监听手势点击
- (void)imgViewClick:(UIGestureRecognizer *)tap
{
    [self advertisementSView:self imageViewDidClickAtIndex:tap.view.tag];
}
//开启定时器
- (void)startTimer
{
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    _timer = timer;
    
    //把timer对象,加入到一个可以通讯的事件循环中去
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark UIScrollViewDelegate

- (void)autoScroll
{
    
    //获得当前停留在的页数
    //如果已经是最后一页,那么从第0也重新开始计算

    NSInteger page = (_pageControl.currentPage >= _pageControl.numberOfPages - 1) ? 0:( _pageControl.currentPage +1);
    //通过人为设置contentOffset的x偏移量,达到滚动效果
    [self setContentOffset:CGPointMake(self.frame.size.width * page , 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"%@",NSStringFromCGPint(scrollView.contentOffset));
    //根据偏移量的变化,计算当前停留的页数
    
        int currentPage =  (scrollView.contentOffset.x +  scrollView.frame.size.width * 0.5)/ scrollView.frame.size.width;
        _pageControl.currentPage = currentPage;
//    NSLog(@"_pageControl.currentPage %lu",currentPage);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //1.取消time
    [_timer invalidate]; //一旦调用了invalidate就相当于杀掉了当前timer,不能够重新的再次启动
    _timer = nil;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //1.开始新的time调用
    if (self.isAddTimer) {
        [self startTimer];
    }
    
}

#pragma mark 自己的代理方法
- (void)advertisementSView:(ZHAdvertisementSView *)scrollView imageViewDidClickAtIndex:(NSInteger)index
{
  [self.ZHDelegate advertisementSView:self imageViewDidClickAtIndex:index];
}
@end
