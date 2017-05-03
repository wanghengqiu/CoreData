//
//  Teacher.h
//  CoreDataDemo
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "TeacherInfo.h"

@interface Teacher : NSManagedObject

@property (nullable,nonatomic,retain) NSNumber* age;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *course;

/** 返回主键*/
+(NSArray* _Nullable)mainKey;

+( NSString* _Nonnull )entityName;

+(void)insertNewObject:( NSString* _Nonnull )name age:(int16_t)age course:(NSString*)course;

-(TeacherInfo*)changeToObject;

@end
