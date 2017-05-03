//
//  Teacher.m
//  CoreDataDemo
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import "Teacher.h"
#import "StoreManager.h"
#import "NSManagedObject+Function.h"

@implementation Teacher

@dynamic age;
@dynamic name;
@dynamic course;

+( NSString* _Nonnull )entityName
{
    return @"Teacher";
}

/** 返回主键*/
+(NSArray*)mainKey
{
    return @[@"name"];
}

+(void)insertNewObject:( NSString* _Nonnull )name age:(int16_t)age course:(NSString*)course
{
    NSManagedObjectContext *context = [[StoreManager sharedStoreManager] getCurContext];
    Teacher *person = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[StoreManager sharedStoreManager] getCurContext]];
    person.name = name;
    person.age = @(age);
    person.course=course;
    [person insertWithContext:context];
}

-(TeacherInfo*)changeToObject
{
    TeacherInfo *info = [[TeacherInfo alloc]init];
    
    info.name = self.name;
    info.age = self.age;
    info.course=self.course;
    
    return info;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"name:%@ age:%d",self.name,self.age];
}

@end
