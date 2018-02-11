//
//  PMRequestManager.m
//  MJ001
//
//  Created by MJ001 on 2017/8/3.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import "PMRequestManager.h"
#import "PMRequestCacheHelper.h"
#import <MJExtension/MJExtension.h>
#import "JsonFormat.h"
#import "NSMutableURLRequest+Auth.h"

#define Default_Request_Timeout_Interval 20.0       // 默认请求超时时间
#define Default_Max_Concurrent_Operation_Count 10   // 默认同时请求最大数

@implementation PMRequestManager

#pragma mark - single manager
+ (instancetype)sharedManager {
    return [[self alloc] initWithBaseURL:nil];
}

+ (instancetype)sharedManagerWithTimeoutInterval:(NSTimeInterval)timeoutInterval {
    return [[self alloc] initWithBaseURL:nil withTimeoutInterval:timeoutInterval];
}

#pragma mark - initial method

- (instancetype)initWithBaseURL:(NSURL *)url {
    return [self initWithBaseURL:url
            sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] timeoutInterval:Default_Request_Timeout_Interval];
}

- (instancetype)initWithBaseURL:(NSURL *)url
            withTimeoutInterval:(NSTimeInterval)timeoutInterval {
    return [self initWithBaseURL:url
            sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                 timeoutInterval:timeoutInterval];
}

- (instancetype)initWithBaseURL:(NSURL *)url
           sessionConfiguration:(NSURLSessionConfiguration *)configuration
            timeoutInterval:(NSTimeInterval)timeoutInterval {
    self = [super initWithBaseURL:url sessionConfiguration:configuration];
    if (self) {
        self.operationQueue.maxConcurrentOperationCount = self.maxConcurrentOperationCount == 0 ? Default_Max_Concurrent_Operation_Count : self.maxConcurrentOperationCount;
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = timeoutInterval;
    }
    return  self;
}


#pragma mark - 请求数据
- (NSURLSessionTask *)requestDataTaskWithServicePath:(NSString *)servicePath
                                       requestMethod:(PMRequestMethod)requestMethod
                                          httpHeader:(NSDictionary *)httpHeader
                                          parameters:(NSDictionary *)parameters
                                       acquirePolicy:(PMAcquireDataMethodType)acquirePolicy
                                        successBlock:(void (^)(NSURLSessionTask *, id))successBlock
                                        failureBlock:(void (^)(NSURLSessionTask *, NSError *))failureBlock {
    
    return [self requestDataTaskWithServicePath:servicePath
                                       cacheKey:servicePath
                                  requestMethod:requestMethod
                                     httpHeader:httpHeader
                                     parameters:parameters
                                  acquirePolicy:acquirePolicy
                                   successBlock:successBlock
                                   failureBlock:failureBlock];

}

- (NSURLSessionTask *)requestDataTaskWithServicePath:(NSString *)servicePath
                                            cacheKey:(NSString *)cacheKey
                                       requestMethod:(PMRequestMethod)requestMethod
                                          httpHeader:(NSDictionary *)httpHeader
                                          parameters:(NSDictionary *)parameters
                                       acquirePolicy:(PMAcquireDataMethodType)acquirePolicy
                                        successBlock:(void (^)(NSURLSessionTask *, id))success
                                        failureBlock:(void (^)(NSURLSessionTask *, NSError *))failure {
//    if (![PMNetStutes NowNetStutes]) {
//        return nil;
//    }
    
    // 读取缓存数据是否成功
    BOOL isCacheSuccess = false;
    
    if (acquirePolicy != PMAcquireServiceDataWithCache && acquirePolicy != PMAcquireServiceDataWithNoCache) {
        // 根据缓存策略得到缓存数据, PMAcquireServiceDataWithMemoryCache 和 PMAcquireServiceDataWithNoCache 无缓存数据返回
        id jsonDic = [PMRequestCacheHelper getCacheDataWithAcquirePolicy:acquirePolicy cacheKey:cacheKey];
        // 读取缓存数据成功
        if (jsonDic) {
//            isCacheSuccess = true;
            success(nil, jsonDic);
            // 如果是 PMAcquireCacheDataWithNoUpdate 和 PMAcquirePersistantCacheDataWithNoUpdate 类型，就直接返回，不再请求数据
            if (acquirePolicy == PMAcquireCacheDataWithNoUpdate || acquirePolicy == PMAcquirePersistantCacheDataWithNoUpdate) {
                return nil;
            }
        }
    }
    
    // 处理请求成功的回调方法，将成功的信息返回上一层, 需要业务层判断是真的成功还是失败
    void (^successBlock)(NSURLSessionTask *, NSData *) = ^(NSURLSessionTask *task, id data){
        // 同步网络时间
        
        if (!success) {
            return;
        }
        
        if (!data) {
            if (!failure) {
                return;
            }
            
            // 结果返回成功, 但是没有返回数据, 这时候做失败处理, 如果读取缓存数据成功，不调用 failure 回调
            if (!isCacheSuccess) {
                failure(task, [[NSError alloc] initWithDomain:@"网络出现波动，请检查网络" code:NSURLErrorZeroByteResource userInfo:nil]);
            } else {
                // 如果读取缓存成功，这时应删除掉改缓存
                [PMRequestCacheHelper removeCacheWithKey:cacheKey acquirePolicy:acquirePolicy];
            }
        }
        
        NSError *error = nil;
        
        id dataDic = nil;
        if ([data isKindOfClass:[NSData class]]) {
            
            dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        }else{
            dataDic = data;
        }
        
        if (error) {
            failure(task, error);
        } else {
            // 如果是 PMAcquireServiceDataWithNoCache 类型，则不更新缓存
            if (acquirePolicy != PMAcquireServiceDataWithNoCache) {
                [PMRequestCacheHelper cacheWithKey:cacheKey data:[dataDic copy] acquirePolicy:acquirePolicy];
            }
            // 打印成功日志
            NSLog(@"request URL:%@\n\nrequest Header:%@\n\nrequest Parameters:%@\n\nresponse JSON:%@", task.currentRequest.URL.absoluteString, task.currentRequest.allHTTPHeaderFields, parameters.JSONString, dataDic);
            // 如果读取缓存数据成功，不调用 success 回调
            if (!isCacheSuccess) {
                success(task, dataDic);
            }
        }
    };
    
    // 处理请求失败的回调方法，直接返回错误
    void (^failureBlock)(NSURLSessionTask *, NSError *) = ^(NSURLSessionTask *task, NSError *error){
        if (!failure) {
            return;
        }
        // 手动取消, 不产生回调
        if (error.code != NSURLErrorCancelled) {
            // 如果读取缓存数据成功，不调用 failure 回调，且这时应删除掉改缓存
            if (!isCacheSuccess) {
                failure(task, error);
            } else {
                [PMRequestCacheHelper removeCacheWithKey:cacheKey acquirePolicy:acquirePolicy];
            }
        }
        // 打印失败日志
        NSLog(@"request URL:%@\n\nrequest Header:%@\n\nrequest Parameters:%@\n\nError description:%@", task.currentRequest.URL.absoluteString, task.currentRequest.allHTTPHeaderFields, parameters.JSONString, error.localizedDescription);
    };
    
    // 设置请求头
    if (httpHeader) {
        [httpHeader enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [self.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    // 分发网络
    switch (requestMethod) {
        case PMRequestMethodGet:
            return [self GET:servicePath parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;
            
        case PMRequestMethodPost:            
            return [self POST:servicePath parameters:parameters progress:nil success:successBlock failure:failureBlock];
            break;
        
        case PMRequestMethodPut:
            return [self PUT:servicePath parameters:parameters success:successBlock failure:failureBlock];
            break;
        
        case PMRequestMethodDelete:
            return [self DELETE:servicePath parameters:parameters success:successBlock failure:failureBlock];
            break;
    }
}


#pragma mark - 带httpBody参数
- (void)sessiondataTaskWithServicePath:(NSURL *)servicePath
                              httpBody:(id  _Nullable)httpBody
                         requestMethod:(PMRequestMethod)requestMethod
                 authorizationUsername:(NSString *)username
                 uathorizationPassword:(NSString *)password
                     completionHandler:(void (^)(NSURLResponse * response, id  responseObject, NSError * error))handler{
    NSMutableURLRequest *commandRequest = [NSMutableURLRequest requestWithURL:servicePath];
    switch (requestMethod) {
        case PMRequestMethodGet:
            [commandRequest setHTTPMethod:@"GET"];
            break;
        case PMRequestMethodPut:
            [commandRequest setHTTPMethod:@"PUT"];
            break;
        case PMRequestMethodDelete:
            [commandRequest setHTTPMethod:@"DELETE"];
            break;
        case PMRequestMethodPost:
        default:
            [commandRequest setHTTPMethod:@"POST"];
            break;
    }
    NSMutableString *bodyStr = [NSMutableString string];
    if ([httpBody isKindOfClass:[NSDictionary class]]) {
        bodyStr = [[JsonFormat stringWithDictionary:httpBody] copy];
        [commandRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    } else {
        bodyStr = [NSMutableString stringWithFormat:@"%@",httpBody];
        [commandRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
    }
    
    //    //这里要改造，如果是局域网的时候，直接发送内网的IP,这个时候就不需要发送UUID
    [commandRequest setUUID:@""];
    
    [commandRequest setHTTPBody:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    if (username.length) {
        [commandRequest setAuthCredentials:username andPassword:password];
    }
    NSLog(@"%@", commandRequest.allHTTPHeaderFields);
    NSURLSessionDataTask *dataTask = [self dataTaskWithRequest:commandRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        handler( response, responseObject, error);
    }];
    [dataTask resume];
}

@end
