//
//  NSString+Wrapper.h
//  
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Wrapper)

/**
 *  验证字符串是否为空
 *
 *  @return true/false
 */
- (BOOL) isNullOrEmpty;

/**
 *  验证字符串是否为字符串空
 *
 *  @return true/false
 */
- (BOOL) isEmpty;

/**
 *  验证字符串是否为NULL
 *
 *  @return true/false
 */
- (BOOL) isNULL;

/**
 *  移除字符串首尾空格
 *
 *  @return 移除首尾空格后的字符串
 */
- (NSString *) trim;

/**
 *  替换原字符串
 *
 *  @param origin      原字符串
 *  @param replacement 替换的字符串
 *
 *  @return 替换后的字符串
 */
- (NSString *) replaceAll:(NSString*)origin with:(NSString*)replacement;

/**
 *  按指定字符分割字符串
 *
 *  @param separator 指定字符串
 *
 *  @return 分离后的数组
 */
- (NSArray *) split:(NSString*) separator;

- (NSString *) toLowerCase;

- (NSString *) toUpperCase;

- (BOOL) equals:(NSString*) anotherString;

- (NSString *) substringFromIndex:(int)beginIndex toIndex:(int)endIndex;

//手机号码中间4位打星号 ****
- (NSString *)handlePhoneNumber;

//检测支付密码是否合法
- (BOOL)checkPayForPWD;

//检测登录密码是否合法
- (int)checkLoginPWD;


/**
 *  每隔4位加一个空格
 *
 *  @return 处理后的数据
 */
- (NSString *)addSpaceBlank;

@end
