//
//  AppUtily.m
//  QiZhiWatch
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import "AppUtily.h"
#import "UIColor+Extern.h"

@implementation AppUtily

+ (UIColor *)colorWithName:(NSString *)name
{
    return [UIColor parserColorStr:name];
}

@end
