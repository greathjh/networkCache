//
//  PMCacheAPIHelper.m
//  MJ001
//
//  Created by MJ001 on 2017/8/4.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import "PMCacheAPIHelper.h"
#import "PMCacheDataManager.h"

@implementation PMCacheAPIHelper

#pragma mark - set cache
+ (void)setCacheModel:(id)model forKey:(NSString *)key {
    [self setCacheModel:model forKey:key isPersistant:false];
}

+ (void)setCacheModel:(id)model
               forKey:(NSString *)key
         isPersistant:(BOOL)isPersistant {
    NSCParameterAssert(model);
    NSCParameterAssert(key.length);
    
    NSString *jsonString;
    if (model && key.length) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if (!jsonString.length) {
            return;
        }
        
        if (isPersistant) {
            [[PMCacheDataManager persistantManager] setCacheObject:jsonString forKey:key];
        } else {
            [[PMCacheDataManager sharedManager] setCacheObject:jsonString forKey:key];
        }
    }
}

#pragma mark - get cache

+ (id)getCacheModelForKey:(NSString *)key {
    return [self getCacheModelForKey:key isPersistant:false];
}

+ (id)getCacheModelForKey:(NSString *)key
             isPersistant:(BOOL)isPersistant {
    NSCParameterAssert(key.length);
    
    if (!key.length) {
        return nil;
    }
    
    NSString *jsonString;
    if (isPersistant) {
        jsonString = [[PMCacheDataManager persistantManager] cacheObjectForKey:key];
    } else {
        jsonString = [[PMCacheDataManager sharedManager] cacheObjectForKey:key];
    }
    
    if (!jsonString.length) {
        return nil;
    }
    
    id jsonDic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers
                                                              error:nil];
    
    return !jsonDic ? nil : jsonDic;
}

#pragma mark - remove cache

+ (void)removeCacheModelForKey:(NSString *)key {
    [self removeCacheModelForKey:key isPersistant:false];
}

+ (void)removeCacheModelForKey:(NSString *)key
                  isPersistant:(BOOL)isPersistant {
    NSCParameterAssert(key.length);
    
    if (!key.length) {
        return;
    }
    
    if (isPersistant) {
        [[PMCacheDataManager persistantManager] removeObjectForKey:key];
    } else {
        [[PMCacheDataManager sharedManager] removeObjectForKey:key];
    }
}

@end
