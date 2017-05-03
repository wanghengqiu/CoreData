//
//  AppUtily.h
//  QiZhiWatch
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kBackgroundColor        @"#efeff4"
#define kNavBackgroundColor     @"#01a8ec"

#define kSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/* 强弱引用的宏*/
#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

#define HEX2RGB(string) [AppUtily colorWithName:string]

#define THEME_COLOR(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define RANDOM_COLOR  THEME_COLOR(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

@interface AppUtily : NSObject

+ (UIColor *)colorWithName:(NSString *)name;

@end
