//
//  PMRequestCacheHelper.m
//  MJ001
//
//  Created by MJ001 on 2017/8/4.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import "PMRequestCacheHelper.h"
#import "PMCacheAPIHelper.h"

@implementation PMRequestCacheHelper

+ (instancetype)shareCenter {
    static id center;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        center = [[self alloc] init];
    });
    return center;
}

+ (void)cacheWithKey:(NSString *)cacheKey
                data:(id)data
       acquirePolicy:(PMAcquireDataMethodType)acquirePolicy {
    NSParameterAssert(cacheKey.length);
    NSParameterAssert(data);
    
    switch (acquirePolicy) {
        case PMAcquirePersistantCacheDataWithUpdate:
        case PMAcquirePersistantCacheDataWithNoUpdate:
            [PMCacheAPIHelper setCacheModel:data forKey:cacheKey isPersistant:true];
            break;
        default:
            [PMCacheAPIHelper setCacheModel:data forKey:cacheKey];
            break;
    }
}

+ (void)removeCacheWithKey:(NSString *)cacheKey
             acquirePolicy:(PMAcquireDataMethodType)acquirePolicy {
    NSParameterAssert(cacheKey.length);
    
    switch (acquirePolicy) {
        case PMAcquirePersistantCacheDataWithUpdate:
        case PMAcquirePersistantCacheDataWithNoUpdate:
            [PMCacheAPIHelper removeCacheModelForKey:cacheKey isPersistant:true];
            break;
            
        default:
            [PMCacheAPIHelper removeCacheModelForKey:cacheKey];
            break;
    }
}

+ (id)getCacheDataWithAcquirePolicy:(PMAcquireDataMethodType)acquirePolicy
                                       cacheKey:(NSString *)cacheKey {
    
    switch (acquirePolicy) {
        case PMAcquireServiceDataWithCache:
        case PMAcquireServiceDataWithNoCache:
            return nil;
            break;
        case PMAcquireCacheDataWithUpdate:
        case PMAcquireCacheDataWithNoUpdate:
            return [PMCacheAPIHelper getCacheModelForKey:cacheKey];
            break;
        case PMAcquirePersistantCacheDataWithUpdate:
        case PMAcquirePersistantCacheDataWithNoUpdate:
            return [PMCacheAPIHelper getCacheModelForKey:cacheKey isPersistant:true];
            break;
        default:
            break;
    }
}

@end
