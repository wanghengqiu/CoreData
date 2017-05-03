//
//  NSManagedObject+Function.m
//  CoreDataDemo
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import "NSManagedObject+Function.h"
#import "StoreManager.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <CoreData/CoreData.h>

@implementation NSManagedObject (Function)

/** 返回表名*/
+(NSString*)entityName
{
    /** 子类实现*/
    return @"";
}

/** 返回主键*/
+(NSArray*)mainKey
{
    /** 子类实现*/
    return [NSArray array];
}

-(id)changeToObject:(id)managedObject
{
    /** 子类实现*/
    return nil;
}

-(void)insertWithContext:(NSManagedObjectContext*)context
{
    NSArray *mainkeys = [[self class] mainKey];
    if (mainkeys.count>0) {
        /** 判断唯一性，当数据库中有该主键的对象，则更新数据库，反之则插入数据库*/
        unsigned int propertyCount = 0;
        objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);
        
        NSString *formatString = @"";
        for (int i=0; i<mainkeys.count; i++) {
            NSString *key = mainkeys[i];
            for (int j=0; j<propertyCount; j++) {
                objc_property_t property = propertyList[j];
                const char *propertyName = property_getName(property);
                NSString* propertyString = [[NSString alloc] initWithUTF8String:propertyName];
                if ([key isEqualToString:propertyString]) {
                    /** 检查该属性是否是主键*/
                    SEL getter = sel_registerName(propertyName);
                    id value = ((id (*) (id,SEL)) objc_msgSend) (self,getter);
                    unsigned int attributeCount = 0;
                    /** 获取主键的类型，用来拼接一个谓语做数据库的唯一性检查*/
                    objc_property_attribute_t *attributeList = property_copyAttributeList(property, &attributeCount);
                    objc_property_attribute_t attribute = attributeList[0];
                    NSString *typeString = [NSString stringWithUTF8String:attribute.value];
                    if ([typeString isEqualToString:@"@\"NSString\""]) {
                        formatString = [formatString stringByAppendingString:[NSString stringWithFormat:@"%@ == \"%@\"",propertyString,(NSString*)value]];
                    } else if ([typeString isEqualToString:@"@\"int16_t\""]) {
                        formatString = [formatString stringByAppendingString:[NSString stringWithFormat:@"%@ == %d",propertyString,(int16_t)value]];
                    } else{
                        
                    }
                    
                    if (i != mainkeys.count-1) {
                        formatString = [formatString stringByAppendingString:@" AND "];
                    }
                }
            }
        }
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[[self class] entityName] inManagedObjectContext:context];
        [request setEntity:entityDescription];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:formatString];
        [request setPredicate:predicate];
        NSError *error = nil;
        NSArray *resultArray = [context executeFetchRequest:request error:&error];
        
        if (resultArray.count == 0) {
            /** 没有存在该主键的对象，此时就直接插入数据库*/
            [context insertObject:self];
            [[StoreManager sharedStoreManager]saveWithContext:context];
        } else {
            /** 如果存在该主键，则更新该对象*/
            for (NSManagedObject *object in resultArray) {
                unsigned int propertyCount = 0;
                objc_property_t *propertyList = class_copyPropertyList([self class], &propertyCount);

                for (int i=0; i<propertyCount; i++){
                    objc_property_t property = propertyList[i];
                    const char *propertyName = property_getName(property);
                    NSString* propertyString = [[NSString alloc] initWithUTF8String:propertyName];
                    if (![mainkeys containsObject:propertyString]) {
                        /** 只更新非主键*/
                        SEL getter = sel_registerName(propertyName);
                        id value = ((id (*) (id,SEL)) objc_msgSend) (self,getter);
                        NSString *setterMethgodName = [NSString stringWithFormat:@"set%@%@:",[propertyString substringToIndex:1].uppercaseString,[propertyString substringFromIndex:1]];
                        SEL setter = sel_registerName(setterMethgodName.UTF8String);
                        if ([object respondsToSelector:setter]) {
                            ((void (*) (id,SEL,id)) objc_msgSend) (object,setter,value);
                        }
                    }
                }
            }
            [context deleteObject:self];
            [[StoreManager sharedStoreManager]saveWithContext:context];
        }
    } else {
        /** 没有主键，直接插入*/
        [context insertObject:self];
        [[StoreManager sharedStoreManager]saveWithContext:context];
    }
}

/** 
 ** predicate:搜索约束。可以为空
 ** orderby:排序方式，支持多键排序，升序就是键值，降序是在键值前面拼接“-”，可以为空
 ** offset:偏移量，表示从多少条开始获取
 ** limit:获取的条数，为0表示获取全部
*/

/** 获取数据*/
+(NSArray*)getObjectList:(NSString *)predicate orderby:(NSArray *)orders offset:(int)offset limit:(int)limit
{
    NSManagedObjectContext *context = [[StoreManager sharedStoreManager]getCurContext];
    NSFetchRequest *request = [self getRequest:context predicate:predicate orderBy:orders offset:offset limit:limit];
    NSError *error = nil;
    NSArray *resultArray = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        return nil;
    }
    
    if (resultArray.count == 0) {
        return nil;
    } else {
        NSMutableArray *finalArr=[NSMutableArray array];
        
        for (NSManagedObject *manageObject in resultArray) {
            id object = [manageObject changeToObject];
            [finalArr addObject:object];
        }
        
        return finalArr;
    }
}

+(NSFetchRequest*)getRequest:(NSManagedObjectContext*)context predicate:(NSString*)predicate orderBy:(NSArray*)orders offset:(int)offset limit:(int)limit
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
    [fetchRequest setEntity:[NSEntityDescription entityForName:className inManagedObjectContext:context]];
    /** 设置约束*/
    if (predicate) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:predicate]];
    }
    
    NSMutableArray *orderArray = [[NSMutableArray alloc]init];
    if (orders != nil) {
        for (NSString *order in orders) {
            NSSortDescriptor *orderDesc = nil;
            if ([[order substringToIndex:1] isEqualToString:@"-"]) {
                /** 降序*/
                orderDesc = [[NSSortDescriptor alloc]initWithKey:[order substringFromIndex:1] ascending:NO];
            } else {
                orderDesc = [[NSSortDescriptor alloc] initWithKey:order
                                                        ascending:YES];
            }
            [orderArray addObject:orderDesc];
        }
        
        [fetchRequest setSortDescriptors:orderArray];
    }
    
    if (offset>0) {
        [fetchRequest setFetchOffset:offset];
    }
    if (limit>0) {
        [fetchRequest setFetchLimit:limit];
    }
    
    return fetchRequest;
}

/** 删除一条记录*/
-(void)deleteObject
{
    NSManagedObjectContext *context=[[StoreManager sharedStoreManager]getCurContext];
    [context deleteObject:self];
    [[StoreManager sharedStoreManager]saveWithContext:context];
}

@end
