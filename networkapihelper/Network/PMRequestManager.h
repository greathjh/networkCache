//
//  PMRequestManager.h
//  MJ001
//
//  Created by MJ001 on 2017/8/3.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "PMRequestCacheHelper.h"

/**
 网络请求的方式

 - PMRequestMethodGet: get
 - PMRequestMethodPost: post
 - PMRequestMethodPut: put
 - PMRequestMethodDelete: delete
 */
typedef NS_ENUM(NSInteger, PMRequestMethod) {
    PMRequestMethodGet,
    PMRequestMethodPost,
    PMRequestMethodPut,
    PMRequestMethodDelete
};

@interface PMRequestManager : AFHTTPSessionManager

/**
 同时进行网络请求的最大数，默认是 10
 */
@property (nonatomic, assign) NSUInteger maxConcurrentOperationCount;

/**
 默认超时时间的初始化，默认是 20 秒

 @return PMRequestManager
 */
+ (instancetype)sharedManager;


/**
 自定义超时时间的初始化

 @param timeoutInterval 超时时间
 @return PMRequestManager
 */
+ (instancetype)sharedManagerWithTimeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 初始化方法

 @param url 服务器根地址
 @param configuration 自定义 URLSessionConfiguration
 @param timeoutInterval 自定义 超时时间
 @return PMRequestManager
 */
- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
                timeoutInterval:(NSTimeInterval)timeoutInterval;

/**
 请求数据 (缓存 key 采用服务器 API 地址的形式)
 
 @param servicePath 服务器 API 地址
 @param requestMethod 请求方式
 @param httpHeader 请求头
 @param parameters 参数
 @param acquirePolicy 读取数据策略
 @param successBlock 请求成功回调
 @param failureBlock 请求失败回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestDataTaskWithServicePath:(NSString *)servicePath
                                       requestMethod:(PMRequestMethod)requestMethod
                                          httpHeader:(NSDictionary *)httpHeader
                                          parameters:(NSDictionary *)parameters
                                       acquirePolicy:(PMAcquireDataMethodType)acquirePolicy
                                        successBlock:(void (^)(NSURLSessionTask *, id))successBlock
                                        failureBlock:(void (^)(NSURLSessionTask *, NSError *))failureBlock;

/**
 请求数据 (缓存 key 采用服务器 API 地址 + 类型参数的形式，用于共用 API 接口的情况)
 
 @param servicePath 服务器 API 地址
 @param cacheKey 缓存 key, 为空时默认是 API 地址
 @param requestMethod 请求方式
 @param httpHeader 请求头
 @param parameters 参数
 @param acquirePolicy 读取数据策略
 @param successBlock 请求成功回调
 @param failureBlock 请求失败回调
 @return NSURLSessionTask
 */
- (NSURLSessionTask *)requestDataTaskWithServicePath:(NSString *)servicePath
                                            cacheKey:(NSString *)cacheKey
                                       requestMethod:(PMRequestMethod)requestMethod
                                          httpHeader:(NSDictionary *)httpHeader
                                          parameters:(NSDictionary *)parameters
                                       acquirePolicy:(PMAcquireDataMethodType)acquirePolicy
                                        successBlock:(void (^)(NSURLSessionTask *, id))successBlock
                                        failureBlock:(void (^)(NSURLSessionTask *, NSError *))failureBlock;

/**
 请求数据 (地址的形式 带httpBody)
 
 @param servicePath 请求servicePath
 @param httpBody 请求httpBody
 @param username 请求用户名
 @param password 密码
 @param handler 回调
 */
- (void)sessiondataTaskWithServicePath:(NSURL *)servicePath
                              httpBody:(id)httpBody
                         requestMethod:(PMRequestMethod)requestMethod
                 authorizationUsername:(NSString *)username
                 uathorizationPassword:(NSString *)password
                     completionHandler:(void (^)(NSURLResponse * response, id  responseObject, NSError * error))handler;

@end
