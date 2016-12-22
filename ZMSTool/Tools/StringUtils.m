//
//  StringUtils.m
//  
//
//  Created by wwwwwww on 15/12/30.
//  Copyright © 2015年 . All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (BOOL)isNullOrEmpty:(NSString *)str {
    
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (str == nil || str == NULL || [str isEqualToString:@""]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

+ (NSArray *)split:(NSString *) string separator:(NSString *)separator {
    return [string componentsSeparatedByString:separator];
}

+ (NSString *)formatAmount:(NSString *)amount {
    
    if (amount.length > 6) {
        //是否有小数点
        if ([amount rangeOfString:@"."].location != NSNotFound) {
            
            NSString *string1 = [[amount componentsSeparatedByString:@"."] objectAtIndex:0];
            NSString *string2 = [[amount componentsSeparatedByString:@"."] objectAtIndex:1];
            
            NSMutableString *newString = [NSMutableString stringWithString:string1];
            
            if (string1.length <= 6 && string1.length >= 4) {
                
                [newString insertString:@"," atIndex:string1.length - 3];
            }
            
            if (string1.length <= 8 && string1.length > 6) {
                
                [newString insertString:@"," atIndex:string1.length % 3];
                [newString insertString:@"," atIndex:string1.length % 3 + 4];
            }
            
            if (string1.length == 9) {
                
                [newString insertString:@"," atIndex:3];
                [newString insertString:@"," atIndex:7];
            }

            [newString appendFormat:@"%@%@",@".",string2];
            
            return newString;
            
        } else {
            
            NSMutableString *newString = [NSMutableString stringWithString:amount];
            [newString insertString:@"." atIndex:amount.length - 2];
            return [self formatAmount:newString];
        }
        
    } else {
        
        if (amount.length < 3) {
            
            if (amount.length == 2) {
                NSString *str = [NSString stringWithFormat:@"0.%@",amount];
                return str;
            }
            
            if (amount.length == 1) {
                NSString *str = [NSString stringWithFormat:@"0.0%@",amount];
                return str;
            }
            
        } else {
            
            if ([amount rangeOfString:@"."].location != NSNotFound){
                return amount;
            } else {
                NSMutableString *newString = [NSMutableString stringWithString:amount];
                [newString insertString:@"." atIndex:amount.length - 2];
                return [self formatAmount:newString];
            }
        }
    }
    
    return amount;
}

+ (BOOL)verifyString:(NSString *)string regx:(NSString *)regx {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regx];
    return [pred evaluateWithObject:string];
}

+ (NSString *)stringFromeDate:(NSDate *)date andFormettle:(NSString *)formettle {
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formettle];
    NSString *  locationString=[dateformatter stringFromDate:date];
    return locationString;
}


+ (BOOL)isIncludeSpecialCharacter:(NSString *)string{
   //是否包含特殊字符
    NSRange specialRange = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"!';.,{}[]<>()/?|+=_-*&^%$#@`~\\"]];
    if (specialRange.location == NSNotFound) {
        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)isIncludeNum:(NSString *)string{
    //是否包含数字
    NSRange characterRange = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"0987654321"]];
    if (characterRange.location == NSNotFound) {
        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)isIncludeCharacter:(NSString *)string{
    
    //是否包含字母
    NSRange characterRange = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"qwertyuioplkjhgfdsazxcvbnmMNBVCXZASDFGHJKLPOIUYTREWQ"]];
    if (characterRange.location == NSNotFound) {
        return NO;
    }
    else{
        return YES;
    }
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


/*+ (NSString *)convertAmountWithIntValue:(id)number {
    
    NSString *returnString       = [NSString stringWithFormat:@"%@",number];
    NSArray *array               = [returnString split:@"."];
    
    NSMutableString *tempString  = [NSMutableString stringWithString:[array firstObject]];
    NSInteger num                = [tempString length];
    while (num > 3) {
        num = num - 3;
        [tempString insertString:@"," atIndex:num];
    }
    returnString = [tempString stringByAppendingString:@"."];
    if (array.count > 1) {
        returnString = [returnString stringByAppendingString:[array lastObject]];
    } else {
        returnString = [returnString stringByAppendingString:@"00"];
    }

    return returnString;
}


+ (NSString *)convertAmountWithDoubleValue:(id)number {

    NSString *returnString       = [StringUtils convertAmountWithIntValue:number];
 
    returnString = [@"￥" stringByAppendingString:returnString];
    
    return returnString;
}
*/


+ (NSString *)translationToChinaeseWithNumber:(NSInteger)arebic {
    
    NSString *str = [NSString stringWithFormat:@"%ld",(long)arebic];
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
   
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i -1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]]) {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {

                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
                
            } else {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
            
            [sums addObject:sum];
        } else {
            [sums addObject:sum];
        }
        
    }
    
    NSString *sumStr = [sums  componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    NSLog(@"%@",str);
    NSLog(@"%@",chinese);
    return chinese;

        
}

/*+ (int)getStringLength:(NSString *)string {

    int stringLength = 0;
    NSString *chinese = @"[\u4e00-\u9fa5]";
    for (int i = 0; i < string.length; i++) {
        NSString *temp = [string substringFromIndex:i toIndex:i + 1];
        if ([self verifyString:temp regx:chinese]) {
            stringLength += 2;
        } else {
            stringLength += 1;
        }
    }
    
    return stringLength;
}
*/
+ (NSString *)convertNUL:(NSString *)string defaultString:(NSString *)defaultString {
    
    if ([self isNullOrEmpty:string]) {
        string = defaultString;
    }
    return string;
}

@end
