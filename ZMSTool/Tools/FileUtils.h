//
//  FileUtils.h
//  
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

/**
 *  获取Documents目录路径
 *  需要持久化的数据请保存在该目录下面
 *
 *  @return 路径
 */
+ (NSString *)getDocumentsDirectory;

/**
 *  获取Cache目录路径
 *  只是临时缓存不需要持久化存储的数据请保存在该目录下面
 *
 *  @return 缓存路径
 */
+ (NSString *)getCacheDirectory;

/**
 *  检验缓存文件是否存在
 *
 *  @param fileName 文件名
 *
 *  @return  yes or no
 */

+ (BOOL)cacheFileExists:(NSString *)fileName;

/**
 *  移除指定文件
 *
 *  @param filePath 文件路径
 *
 *  @return 成功与否
 */
+ (BOOL)removeFileAtPath:(NSString *)filePath;

@end
