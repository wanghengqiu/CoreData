//
//  StoreManager.m
//  CoreDataDemo
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import "StoreManager.h"

@interface StoreManager ()

/** 创建一个主队列mainManagedObjectContext，和一个或多个私有队列的backgroundMOC。将所有backgroundMOC的parentContext设置为mainManagedObjectContext，将耗时操作都放在backgroundMOC中执行，mainMOC负责所有和UI相关的操作。所有和UI无关的工作都交给backgroundMOC，在backgroundMOC对数据发生改变后，调用save方法会将改变push到mainMOC中，再由mainMOC执行save方法将改变保存到存储区*/
@property (strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation StoreManager

+ (StoreManager *)sharedStoreManager
{
    static StoreManager *storeManagerr = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        storeManagerr = [[self alloc] init];
    });
    return storeManagerr;
}

-(NSManagedObjectContext*)getCurContext
{
    if ([[NSThread currentThread] isEqual:[NSThread mainThread]]) {
        /** 主线程使用*/
        return self.mainManagedObjectContext;
    } else {
        /** 子线程中使用一个新建的*/
        NSManagedObjectContext *backgoundManagedObjectCotext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        backgoundManagedObjectCotext.parentContext = self.mainManagedObjectContext;
        return backgoundManagedObjectCotext;
    }
}

-(void)saveWithContext:(NSManagedObjectContext*)context
{
    [context performBlock:^{
        NSError *error1 = nil;
        [context save:&error1];
        if (context != self.mainManagedObjectContext) {
            [[StoreManager sharedStoreManager].mainManagedObjectContext performBlock:^{
                NSError *error2 = nil;
                [[StoreManager sharedStoreManager].mainManagedObjectContext save:&error2];
            }];
        }
    }];
}

-(NSManagedObjectModel*)managedObjectModel
{
    if (_managedObjectModel!=nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelUrl = [[NSBundle mainBundle]URLForResource:@"CoreDataDemo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelUrl];
    return _managedObjectModel;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    NSURL *storeUrl = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"CoreDataDemo.sqlite"];
    NSError *error = nil;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"初始化数据库出错";
        dict[NSLocalizedFailureReasonErrorKey] = @"加载数据库出错";
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext*)mainManagedObjectContext
{
    if (_mainManagedObjectContext!=nil) {
        return _mainManagedObjectContext;
    }
    
    _mainManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [_mainManagedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _mainManagedObjectContext;
}

@end
