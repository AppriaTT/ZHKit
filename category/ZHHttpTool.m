//
//  ZHHttpTool.m
//  LinkHere(R)
//
//  Created by Aaron on 3/9/16.
//  Copyright © 2016 LinkHere. All rights reserved.
//

#import "ZHHttpTool.h"

static AFHTTPSessionManager *_shareManager = nil;

@implementation ZHHttpTool

//懒加载管理者
+(AFHTTPSessionManager *)shareMangager
{
    if (!_shareManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _shareManager = [AFHTTPSessionManager manager];
            // 设置网络超时的时间，10秒。
            _shareManager.requestSerializer.timeoutInterval = 10;
            // 设置接收的格式
            _shareManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        });
    }
    return _shareManager;
}


+(void)Get:(NSString *)urlString parameters:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure
{
    AFHTTPSessionManager *session = [self shareMangager];
    
    if (session.reachabilityManager.reachable) {
        session.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    }
    else
    {
        session.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
    }
    
//    [session GET:urlString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failure(error);
//    }];
    
    [session GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+(void)Post:(NSString *)urlString parameters:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure
{
 
    AFHTTPSessionManager *session = [self shareMangager];

//    [session POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        success (responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        failure (error);
//    }];
    
    [session POST:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
  
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success (responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure (error);
    }];
}
@end
