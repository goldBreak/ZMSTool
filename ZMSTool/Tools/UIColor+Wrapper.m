//
//  UIColor+Wrapper.m
//  
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import "UIColor+Wrapper.h"

@implementation UIColor (Wrapper)

+ (UIColor *)colorWithHexString:(NSString *)hexColorString {
    return [UIColor colorWithHexString:hexColorString andAlpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexColorString andAlpha:(CGFloat)alpha {
    NSString *cString = [[hexColorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if ([cString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end
