//
//  UIColor+Wrapper.h
//
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Wrapper)


+ (UIColor *)colorWithHexString:(NSString *)hexColorString;

/**
 *  十六进制颜色码转换成iOS可用的RGB
 *
 *  @param hexColorString 十六进制颜色码
 *  @param alpha 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)hexColorString andAlpha:(CGFloat)alpha;

@end
