//
//  ViewController.m
//  newFeature
//
//  Created by arron on 16/4/18.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"

#define zoomDistance 30
//#define redAreaHeight zoomDistance
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *table;
@end

@implementation ViewController
{
    BOOL _isHideNVBar;
    NSInteger _time;
    NSInteger _lastContentOffSetY;
    
    UIImageView *_imageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBarHidden = YES;
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor redColor];
    self.table = tableView;
    self.table.frame = CGRectMake(0, 40 + zoomDistance, self.view.frame.size.width, self.view.frame.size.height);
    self.table.showsVerticalScrollIndicator = NO;
    //图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40 + zoomDistance, 40 + zoomDistance)];
    imageView.backgroundColor = [UIColor blueColor];
    imageView.layer.cornerRadius = (40 + zoomDistance ) /2;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    _imageView = imageView;
    
    self.table.contentInset = UIEdgeInsetsMake(zoomDistance - 20, 0, - zoomDistance + 20, 0);
    _time = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ce''"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ce''"];
    }
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

#pragma mark 上拉放缩头像 
- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    //_lastcontentoffset上一次滑动的距离
    CGFloat scale = -scrollView.contentOffset.y / zoomDistance;
    //
    if (scrollView.contentOffset.y > 0) {
        scale = 0;
    } else if (scrollView.contentOffset.y < - zoomDistance)
    {
        scale = 1;
    }
        _imageView.frame = CGRectMake( 10, 10, 20 + zoomDistance + scale  * zoomDistance, 20+zoomDistance + scale * zoomDistance);
        _imageView.layer.cornerRadius = (20 + zoomDistance + scale  * zoomDistance)/2;
}
#pragma mark 上拉隐藏导航栏, 下拉显示

//- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
//    //_lastcontentoffset上一次滑动的距离
//    if(scrollView.contentOffset.y>0) {
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        
//        if(scrollView.contentOffset.y-_lastContentOffSetY<=0) {
//            [self.navigationController setNavigationBarHidden:NO animated:YES];
//        }
//    }
//    _lastContentOffSetY=scrollView.contentOffset.y;
//}
@end
