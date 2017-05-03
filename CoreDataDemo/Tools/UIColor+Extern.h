//
//  UIColor+Extern.h
//  QiZhiWatch
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extern)

/*
 * @Desc:
 *      将颜色字符串转换为具体的颜色
 *
 * @params:
 *      value: 颜色的数值
 *
 * @Note:
 *      value的格式如下：
 *          1. #rrggbb
 *          2. #rrggbbaa
 *          3. rrggbb
 *          4. *rrrgggbbb
 *          5. *rrrgggbbbaaa
 *
 *      在1 2 3这三种格式下，r g b的值需要是2位16进制，而4 5两种情况下，需要是3位10进制
 */
+ (UIColor *)parserColorStr:(NSString *)value;

// 格式为：RRGGBBAA
- (NSString *)getRGBAFormat;

// 格式为：RRGGBB
- (NSString *)getRGBFormat;

/**
 *  解析16进制格式的颜色
 *  格式必须为 '#' + 6位或者8位长度的字符串
 */
+ (UIColor *)parserColorWithHexString:(NSString *)string;

@end
