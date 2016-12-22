//
//  CacheUtils.m
//
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import "CacheUtils.h"
#import "FileUtils.h"
#import "StringUtils.h"

@implementation CacheUtils

static CacheUtils *instance = nil;
static NSCache    *cache = nil;
static NSString   *cacheDirectory = nil;
static dispatch_once_t predicate;

+ (instancetype)shareCache {
    
    dispatch_once(&predicate, ^{
        instance = [[CacheUtils alloc] init];
        //
        cache = [[NSCache alloc] init];
        //初始化缓存参数
        //cache.countLimit = 50;
//        cache.totalCostLimit = 1024 * 5;
        //获取缓存目录
        cacheDirectory = [FileUtils getCacheDirectory];
    });
    return instance;
}

- (void)cacheImage:(NSData *)cacheData forKey:(NSString *)key {
    
    dispatch_queue_t queue = dispatch_queue_create("memedai.cacheImage", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //检查是否已经存在,如果存在先删除，然后再缓存
        if ([cache objectForKey:key]) {
            [cache removeObjectForKey:key];
        }
        
        //判断文件的大小是否过大，如果过大就不缓存在内存中
        NSInteger dataSize = [cacheData length] / 1024; //kb
        if (dataSize > 0 && dataSize < 350) {
            //写入内存
            [cache setObject:cacheData forKey:key];
        }
        
        //获取缓存目录
        if ([StringUtils isNullOrEmpty:cacheDirectory]) {
            cacheDirectory = [FileUtils getCacheDirectory];
        }
        
        //拼接文件缓存路径
        NSString *path = cacheDirectory;
        NSString *filePath = [path stringByAppendingPathComponent:key];
//        NSLog(@"*****存储磁盘路径：%@", path);
        
        //判断磁盘中是否已经存在，如果存在先移除，再写入
        if ([FileUtils cacheFileExists:key]) {
            [FileUtils removeFileAtPath:filePath];
        }
        
        //写入磁盘永久缓存
        [cacheData writeToFile:filePath atomically:YES];
    });
}

- (NSData *)loadCacheImageForKey:(NSString *) key {
    
    if ([StringUtils isNullOrEmpty:key]) {
        return nil;
    }
    
    NSData *cacheData = [cache objectForKey:key];
//    NSLog(@"*****从内存中读取的数据：%lukb", (unsigned long)cacheData.length/1024);
    
    //内存中是否存在，如果不存在从磁盘读取
    if (!cacheData) {
        
        //判断磁盘缓存目录是否存在
        if ([FileUtils cacheFileExists:key]) {
            
            NSString *path = cacheDirectory;
            NSString *filePath = [path stringByAppendingPathComponent:key];
            
            //写入磁盘缓存目录
            cacheData = [NSData dataWithContentsOfFile:filePath];
//            NSLog(@"*****从磁盘中读取的数据：%lukb", (unsigned long)cacheData.length/1024);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //判断文件的大小是否过大，如果过大就不缓存在内存中
                NSInteger dataSize = [cacheData length] / 1024; //kb
                if (dataSize > 0 && dataSize < 350) {
                    //缓存在内存中,便于下次快速读取
                    [cache setObject:cacheData forKey:key];
                }
            });
        }
    }
    return cacheData;
}

- (BOOL)cacheIsExistForRUL:(NSString *) URLString {
    
    if ([StringUtils isNullOrEmpty:URLString]) {
        return NO;
    }
    
    NSData *cacheData = [cache objectForKey:URLString];
    //内存中是否存在，如果不存在从磁盘读取
    if (!cacheData) {
        //判断磁盘缓存目录是否存在
        if ([FileUtils cacheFileExists:URLString]) {
            return YES;
        } else {
            return NO;
        }
        
    } else {
        
        cacheData = nil;
        return YES;
    }
    return NO;
}
@end
