//
//  StoreManager.h
//  CoreDataDemo
//
//  Created by 王恒求 on 2016/8/22.
//  Copyright © 2016年 王恒求. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface StoreManager : NSObject

+ (StoreManager *)sharedStoreManager;

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

-(NSManagedObjectContext*)getCurContext;

-(void)saveWithContext:(NSManagedObjectContext*)context;

@end
