//
//  CacheUtils.h
//  
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMDCommonUserModel;

@interface CacheUtils : NSObject

+ (instancetype)shareCache;

/**
 *  缓存图片
 *
 *  @param cacheData 图片流
 *  @param key       图片名称
 */
- (void)cacheImage:(NSData *)cacheData forKey:(NSString *) key;

/**
 *  加载缓存图片
 *
 *  @param key 图片名称
 *
 *  @return 图片二进制
 */
- (NSData *)loadCacheImageForKey:(NSString *) key;

/**
 *  判断缓存是否存在
 *
 *  @param URLString 图片的URL
 *
 *  @return 存在则返回YES
 */
- (BOOL)cacheIsExistForRUL:(NSString *) URLString;

@end
