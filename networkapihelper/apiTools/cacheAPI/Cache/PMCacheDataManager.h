//  
//  PMCacheDataManager.h
//  MJ001
//
//  Created by MJ001 on 2017/8/2.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINCache.h"

@interface PMCacheDataManager : NSObject

// 缓存大小
@property (readonly) NSUInteger cacheSize;
// 缓存在磁盘上的最大限制大小
@property (nonatomic, assign) NSUInteger byteLimit;

/**
 Cache 下的缓存, 清空缓存会删除所有缓存数据

 @return PMCacheDataManager
 */
+ (instancetype)sharedManager;

/**
 Document 下缓存, 需要手动清除, 缓存重要数据
 
 @return PMCacheDataManager
 */
+ (instancetype)persistantManager;


/**
 初始化 manager
 缓存数据管理器(默认全部缓存在 /caches/139PushMail 路径下,
 如果想自己维护缓存路径, 请使用 initWithName: / initWithName:path: 方法实例化并持有)
 为了增加代码可读性, key 在传入的时候不需要进行 MD5 转换
 
 @return PMCacheDataManager
 */
- (instancetype)init;
- (instancetype)initWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name path:(NSString *)path;


/**
 缓存对象

 @param object 对象
 @param string key
 */
- (void)setCacheObject:(id <NSCoding>)object forKey:(NSString *)string;
- (void)setCacheObject:(id <NSCoding>)object forKey:(NSString *)key completionHandler:(void (^)(void))block;


/**
 读取缓存

 @param key
 @return 对象
 */
- (id)cacheObjectForKey:(NSString *)key;
- (void)cacheObjectForKey:(NSString *)key completionHandler:(void (^)(NSString *, id))block;


/**
 删除缓存

 @param key
 */
- (void)removeObjectForKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key completionHandler:(void (^)(NSString *))block;

/**
 删除全部缓存
 */
- (void)removeAllObjects;
- (void)removeAllObjectsWithCompletionHandler:(void (^)(void))block;

@end
