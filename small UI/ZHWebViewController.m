//
//  ZHNewsDetailReadController.m
//  足球控(DIY)
//
//  Created by qianfeng on 16/1/10.
//  Copyright (c) 2016年 叶无道. All rights reserved.
//
#import "ZHWebViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "MBProgressHUD+MJ.h"
#import "UIWebView+AFNetworking.h"
#import "ZHRecomAPI.h"

#import "ZHFood.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "XPathQuery.h"
#import "LLCookController.h"
@interface ZHWebViewController ()<UIWebViewDelegate>
@property (nonatomic,weak)UIWebView *webView;


@property (nonatomic,copy)NSArray *foods;
@end

@implementation ZHWebViewController
{
    NSString *_HTML;
    UIProgressView *_progressView;
}
+(instancetype)controllerWithUrl:(NSString *)urlString
{
    ZHWebViewController *vc = [[ZHWebViewController alloc]init];
    vc.urlString = urlString;
    return vc;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_HTML) {
        [self setupWebView];
        [self.webView loadHTMLString:_HTML baseURL:[NSURL URLWithString:_urlString]];
    }
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupNVbar];
        [self setupWebView];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark setupUI
- (void)setupNVbar
{
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemAndTarget:self action:@selector(backClick)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(webViewRefresh)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"webgo_88"] style:UIBarButtonItemStylePlain target:self action:@selector(webViewGo)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"webback_88"] style:UIBarButtonItemStylePlain target:self action:@selector(webViewBack)];
    
    self.navigationItem.rightBarButtonItems = @[item,item2,item3];
}
#pragma mark webView的一系列顶部栏操作
-(void)webViewBack
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else
    {
        [self.webView loadHTMLString:_HTML baseURL:[NSURL URLWithString:_urlString]];
    }
}
-(void)webViewGo
{
    [self.webView goForward];
}
-(void)webViewRefresh
{
    [self.webView reload];
}
- (void)shareClick
{
    NSLog(@"点击了分享");
}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)
- (void)setupWebView
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView = webView;
    self.webView.y = self.webView.y +44 + 20;
    self.webView.height -= 64;
    self.webView.scalesPageToFit = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.delegate = self;
    [self.view addSubview:webView];
    webView.backgroundColor = [UIColor whiteColor];
    //创建 进度条
    UIProgressView *progressview = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:progressview];
    _progressView = progressview;
    _progressView.tintColor = [UIColor orangeColor];
    progressview.frame = CGRectMake(0, 64, screenW, 2);
}

-(void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    request.timeoutInterval = 15;
    
    //加载请求,并更新进度条
        [self.webView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            [_progressView setProgress:totalBytesWritten/totalBytesExpectedToWrite animated:YES];
        } success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
            //解析文本将 html 和 recipe 对应起来, 保存模型 处理接下来的 交互事件
            self.foods = [self generateData:HTML];
            _HTML = HTML;
            return HTML;
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
}

//解析一下特殊数据
- (NSArray *)generateData:(NSString *)dataString
{
    NSData *htmlData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    //先搜索带a 的节点
    NSString *nodeString =@"//a";// @"/html/body/div[@class=\"cpstyle1 clearfix\"]";
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray *elements  = [xpathParser searchWithXPathQuery:nodeString];
    NSMutableArray *array = [NSMutableArray array];
    //将有recipe_id的节点保存起来
    for (TFHppleElement *element in elements) {
        NSArray *keys = [element.attributes allKeys];
        BOOL jump = NO;
        for (NSString *key in keys) {
            if ([key isEqualToString:@"recipe_id"]) {
                jump = YES;
            }
        }
        if (jump) {
            [array addObject:element];
        }
    }
    NSMutableArray *foods = [NSMutableArray array];
    //将节点转换成 ZHFood模型
    for (TFHppleElement *element in array) {
        ZHFood *food = [ZHFood new];
        food.urlString = element.attributes[@"href"];
        food.Id = element.attributes[@"recipe_id"];
        [foods addObject:food];
    }
    return foods;
}


#pragma mark UIWebViewDelegate
//webView与app交互
- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *path=[[request URL] absoluteString];
    //判断是否 需要跳转到app中进行查看
    for (ZHFood *food in self.foods) {
        if ([food.urlString isEqualToString:path]) {
            LLCookController *llVC = [LLCookController cookControllerWithId:food.Id];
            [self.navigationController pushViewController:llVC animated:YES];
            return NO;
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"didFailLoadWithError");
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView removeFromSuperview];
}
@end
