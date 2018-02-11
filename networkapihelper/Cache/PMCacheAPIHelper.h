//
//  PMCacheAPIHelper.h
//  MJ001
//
//  Created by MJ001 on 2017/8/4.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMCacheAPIHelper : NSObject

/**
 缓存模型，需要持久化保存的数据，isPersistant 传入 true，默认为 false
 
 @param model 模型
 @param key 名字
 */
+ (void)setCacheModel:(id)model forKey:(NSString *)key;
+ (void)setCacheModel:(id)model forKey:(NSString *)key isPersistant:(BOOL)isPersistant;


/**
 读取缓存，默认 isPersistant 传入 false
 
 @param key 名字
 @return 模型
 */
+ (id)getCacheModelForKey:(NSString *)key;
+ (id)getCacheModelForKey:(NSString *)key isPersistant:(BOOL)isPersistant;


/**
 删除缓存，默认 isPersistant 传入 false
 
 @param key 名字
 */
+ (void)removeCacheModelForKey:(NSString *)key;
+ (void)removeCacheModelForKey:(NSString *)key isPersistant:(BOOL)isPersistant;

@end
