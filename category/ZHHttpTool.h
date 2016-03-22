//
//  ZHHttpTool.h
//  LinkHere(R)
//
//  Created by Aaron on 3/9/16.
//  Copyright © 2016 LinkHere. All rights reserved.


#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ZHHttpTool : NSObject
/**
 *  基于AFNetworking 3.0 的网络请求 get请求
 */
+(void)Get:(NSString *)urlString parameters:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;
/**
 *  基于AFNetworking 3.0 的网络请求 post请求
 */
+(void)Post:(NSString *)urlString parameters:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError * error))failure;

@end
