//
//  PMCacheDataManager.m
//  MJ001
//
//  Created by MJ001 on 2017/8/2.
//  Copyright © 2018年 立通无限. All rights reserved.
//

#import "PMCacheDataManager.h"

#define Cache_Define_Directory   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject
#define Cache_Default_Directory   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true).firstObject

#define Default_Disk_Cache_Size 1024 * 1024 * 100   // 100M

@interface PMCacheDataManager ()

@property (nonatomic, strong) PINCache *cache;

@end

@implementation PMCacheDataManager

#pragma mark - single manager
+ (instancetype)sharedManager {
    static id manager;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

+ (instancetype)persistantManager {
    static id manager;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        manager = [[self alloc] initWithName:@"139PushMail" path:Cache_Define_Directory];
    });
    return manager;
}

#pragma mark - initial methods
- (instancetype)init {
    self = [super init];
    if (self) {
        return [self initWithName:@"139PushMail"];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    return [self initWithName:name path:Cache_Default_Directory];
}

- (instancetype)initWithName:(NSString *)name path:(NSString *)path {
    self = [super init];
    if (self) {
        self.cache = [[PINCache alloc] initWithName:name rootPath:path];
        self.cache.diskCache.byteLimit = Default_Disk_Cache_Size; // 100M
    }
    return self;
}

#pragma mark - set methods
- (void)setCacheObject:(id <NSCoding>)object
                forKey:(NSString *)string {
    [self.cache setObject:object forKey:string];
}

- (void)setCacheObject:(id <NSCoding>)object
                forKey:(NSString *)key
     completionHandler:(void (^)(void))block {
    [self.cache setObject:object forKey:key block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
        block();
    }];
}

#pragma mark - get methods
- (id)cacheObjectForKey:(nonnull NSString *)key {
    id object = [self.cache objectForKey:key];
    if (nil == object) {
        return nil;
    }
    return object;
}

- (void)cacheObjectForKey:(nonnull NSString *)key completionHandler:(void (^)(NSString *_Nonnull, id _Nullable))block {
    [self.cache objectForKey:key block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
        if (nil == object) {
            block(key, nil);
        } else {
            block(key, object);
        }
    }];
}

#pragma mark - remove methods
- (void)removeObjectForKey:(nonnull NSString *)key {
    [self.cache removeObjectForKey:key];
}

- (void)removeObjectForKey:(nonnull NSString *)key
         completionHandler:(void (^)(NSString *_Nonnull))block {
    [self.cache removeObjectForKey:key block:^(PINCache * _Nonnull cache, NSString * _Nonnull key, id  _Nullable object) {
        block(key);
    }];
}

- (void)removeAllObjects {
    [self.cache removeAllObjects];
}

- (void)removeAllObjectsWithCompletionHandler:(void (^)(void))block {
    [self.cache removeAllObjects:^(PINCache * _Nonnull cache) {
        block();
    }];
}

#pragma mark - getter and setter
- (NSUInteger)cacheSize {
    UInt64 size = self.cache.diskCache.byteCount;
    return size;
}

- (void)setByteLimit:(NSUInteger)byteLimit {
    if (byteLimit != 0) {
        self.cache.diskCache.byteLimit = byteLimit;
    }
}

@end
