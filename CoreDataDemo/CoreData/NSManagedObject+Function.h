//
//  NSManagedObject+Function.h
//  CoreDataDemo
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Function)

/** 返回表名*/
+(NSString*)entityName;

/** 返回主键*/
+(NSArray*)mainKey;

-(id)changeToObject;

/** 插入一条记录进入数据库*/
-(void)insertWithContext:(NSManagedObjectContext*)context;

/**
 ** predicate:搜索约束。可以为空
 ** orderby:排序方式，支持多键排序，升序就是键值，降序是在键值前面拼接“-”，可以为空
 ** offset:偏移量，表示从多少条开始获取
 ** limit:获取的条数，为0表示获取全部
*/
+(NSArray*)getObjectList:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit;

-(void)deleteObject;

@end
