//
//  UIColor+Extern.m
//  QiZhiWatch
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import "UIColor+Extern.h"

@implementation UIColor (Extern)

+ (NSInteger)getColorValueOf16:(NSString *)str
{
    if (str.length == 0) {
        return 0;
    }
    NSInteger num = 0;
    NSInteger len = str.length;
    for (NSInteger index = 0; index < len; index ++) {
        NSString *valueStr = [str substringWithRange:NSMakeRange(index, 1)];
        NSInteger value = [valueStr integerValue];
        if (![valueStr compare:@"a" options:NSCaseInsensitiveSearch]) {
            value = 10;
        } else if (![valueStr compare:@"b" options:NSCaseInsensitiveSearch]) {
            value = 11;
        } else if (![valueStr compare:@"c" options:NSCaseInsensitiveSearch]) {
            value = 12;
        } else if (![valueStr compare:@"d" options:NSCaseInsensitiveSearch]) {
            value = 13;
        } else if (![valueStr compare:@"e" options:NSCaseInsensitiveSearch]) {
            value = 14;
        } else if (![valueStr compare:@"f" options:NSCaseInsensitiveSearch]) {
            value = 15;
        }
        NSInteger k = len - index - 1;
        while (k > 0) {
            value *= 16;
            k --;
        }
        num += value;
    }
    return num;
}

+ (UIColor *)parserColorStr10:(NSString *)str
{
    if (!str.length) {
        return nil;
    }
    if ([str hasPrefix:@"*"]) {
        str = [str substringFromIndex:1];
    }
    if (str.length != 9 && str.length != 12) {
        return nil;
    }
    NSInteger red = 0;
    NSInteger green = 0;
    NSInteger blue = 0;
    CGFloat alpha = 1.0;
    
    red = [str substringWithRange:NSMakeRange(0, 3)].integerValue;
    green = [str substringWithRange:NSMakeRange(3, 3)].integerValue;
    blue = [str substringWithRange:NSMakeRange(6, 3)].integerValue;
    
    if (str.length == 12) {
        NSInteger a = [[str substringWithRange:NSMakeRange(9, 3)] integerValue];
        alpha = (a / 255.0);
    }
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

+ (UIColor *)parserColorStr:(NSString *)str
{
    if (!str.length) {
        return nil;
    }
    // 10进制
    if ([str hasPrefix:@"*"]) {
        return [UIColor parserColorStr10:str];
    }
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    }
    if (str.length != 6 && str.length != 8) {
        return nil;
    }
    
    NSInteger red = 0;
    NSInteger green = 0;
    NSInteger blue = 0;
    CGFloat alpha = 1.0;
    
    red = [UIColor getColorValueOf16:[str substringWithRange:NSMakeRange(0, 2)]];
    green = [UIColor getColorValueOf16:[str substringWithRange:NSMakeRange(2, 2)]];
    blue = [UIColor getColorValueOf16:[str substringWithRange:NSMakeRange(4, 2)]];
    
    if (str.length == 8) {
        NSInteger a = [UIColor getColorValueOf16:[str substringWithRange:NSMakeRange(6, 2)]];
        alpha = (a / 255.0);
    }
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

#pragma mark -

- (NSString *)getRGBAFormat
{
    CGFloat red = 0;
    CGFloat greed = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    [self getRed:&red green:&greed blue:&blue alpha:&alpha];
    red *= 255;
    greed *= 255;
    blue *= 255;
    alpha *= 255;
    NSString *format = [NSString stringWithFormat:@"%02dx%02dx%02dx%02dx", (int)red, (int)greed, (int)blue, (int)alpha];
    return format;
}

- (NSString *)getRGBFormat
{
    CGFloat red = 0;
    CGFloat greed = 0;
    CGFloat blue = 0;
    [self getRed:&red green:&greed blue:&blue alpha:NULL];
    red *= 255;
    greed *= 255;
    blue *= 255;
    NSString *format = [NSString stringWithFormat:@"%02dx%02dx%02dx", (int)red, (int)greed, (int)blue];
    return format;
}

#pragma mark -

/**
 *  解析16进制格式的颜色
 *  格式必须为 '#' + 6位或者8位长度的字符串
 */
+ (UIColor *)parserColorWithHexString:(NSString *)string
{
    if (!string.length) {
        return nil;
    }
    if ([string hasPrefix:@"#"]) {
        string = [string substringFromIndex:1];
    }
    if (string.length != 6 && string.length != 8) {
        return nil;
    }
    
    unsigned int a = 255, r, g, b;
    NSRange range;
    range.location = 0;
    range.length = 2;
    BOOL isAlphaValid = YES;
    
    NSString *astring;
    if (string.length == 8) {
        astring = [string substringWithRange:range];
        range.location += 2;
        isAlphaValid = [[NSScanner scannerWithString:astring] scanHexInt:&a];
    }
    NSString *rString = [string substringWithRange:range];
    range.location += 2;
    NSString *gString = [string substringWithRange:range];
    range.location += 2;
    NSString *bString = [string substringWithRange:range];
    if ([[NSScanner scannerWithString:rString] scanHexInt:&r] &&
        [[NSScanner scannerWithString:gString] scanHexInt:&g] &&
        [[NSScanner scannerWithString:bString] scanHexInt:&b] &&
        isAlphaValid) {
        return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) a / 255.0f)];
    }
    return nil;
}

@end
