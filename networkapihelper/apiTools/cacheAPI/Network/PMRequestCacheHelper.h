//
//  PMRequestCacheHelper.h
//  MJ001
//
//  Created by MJ001 on 2017/8/4.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMRequestCacheHelper : NSObject

/**
 获取数据的策略
 
 - PMAcquireServiceDataWithCache: 从服务器获取数据, 并缓存, 数据不持久
 - PMAcquireServiceDataWithNoCache: 从服务器获取数据，无缓存
 - PMAcquireCacheDataWithUpdate: 从缓存中获取不持久数据，并从服务器获取最新的数据，更新
 - PMAcquirePersistantCacheDataWithUpdate: 从缓存中获取持久数据，并从服务器获取最新的数据，更新
 - PMAcquireCacheDataWithNoUpdate: 从缓存中获取不持久数据，无需向服务器获取最新的数据
 - PMAcquirePersistantCacheDataWithNoUpdate: 从缓存中获取持久数据，无需向服务器获取最新的数据
 */
typedef NS_ENUM(NSInteger, PMAcquireDataMethodType) {
    PMAcquireServiceDataWithCache,
    PMAcquireServiceDataWithNoCache,
    PMAcquireCacheDataWithUpdate,
    PMAcquirePersistantCacheDataWithUpdate,
    PMAcquireCacheDataWithNoUpdate,
    PMAcquirePersistantCacheDataWithNoUpdate
};

/**
 单例方法
 
 @return PMRequestCenter
 */
+ (instancetype)shareCenter;

/**
 数据缓存
 
 @param cacheKey 缓存 key
 @param data 目标数据
 @param acquirePolicy 获取数据策略
 */
+ (void)cacheWithKey:(NSString *)cacheKey
                data:(id)data
       acquirePolicy:(PMAcquireDataMethodType)acquirePolicy;


/**
 删除缓存

 @param cacheKey 缓存 key
 @param acquirePolicy 获取数据策略
 */
+ (void)removeCacheWithKey:(NSString *)cacheKey
             acquirePolicy:(PMAcquireDataMethodType)acquirePolicy;


/**
 获取数据缓存
 
 @param acquirePolicy 获取数据策略
 @param cacheKey 缓存 key
 @return 缓存
 */
+ (id)getCacheDataWithAcquirePolicy:(PMAcquireDataMethodType)acquirePolicy
                                       cacheKey:(NSString *)cacheKey;


@end
