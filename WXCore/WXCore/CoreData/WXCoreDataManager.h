//
//  WXCoreDataManager.h
//  WXCore
//
//  Created by 朱洪伟 on 15/6/30.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WXCoreDataManager : NSObject
@property (nonatomic, strong) NSString *modelFileName;
@property (nonatomic, strong) NSString *persistentFileName; //@"LSCoreData.sqlite"

@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;

@property (nonatomic, readonly) NSManagedObjectContext *rootMOC; // For IO
@property (nonatomic, readonly) NSManagedObjectContext *mainMOC; // For UI, just for read
@property (nonatomic, readonly) NSManagedObjectContext *persistWorkMOC; // For background, and write

// for user config
@property (nonatomic, strong) NSMutableDictionary *uploadMap;           // NSDictionary -> Upload Dictionary(remove some keys)
@property (nonatomic, strong) NSMutableDictionary *objectNameMap;       // Dictionary -> NSManagerObject
@property (nonatomic, strong) NSMutableDictionary *objectNameDeMap;       // Dictionary <- NSManagerObject

// for internal use
@property (nonatomic, strong) NSMutableDictionary *cacheMap;            // Dictionary -> NSManagerObject
@property (nonatomic, strong) NSMutableDictionary *cacheDeMap;          // NSManagerObject -> Dictionary
@property (nonatomic, strong) NSMutableDictionary *classNameMap;        // className -> EntityName

+ (NSString *)randCachePath;

+ (NSString*)soundPathForCurrentUser:(long long)soundId sendByMe:(BOOL)sendByMe;
+ (NSString*)imagePathForCurrentUser:(long long)imageId;

+ (NSString *)currentUid;
//+ (WXCoreDataManager *)manager;
//+ (void)disconnectData;


//- (BOOL)connectData;
//- (BOOL)saveContext:(NSManagedObjectContext *)savedMoc ToPersistentStore:(NSError **)error;

//- (void)performBlock:(void (^)(NSManagedObjectContext *workMOC))block;
//- (void)performBlock:(void (^)(NSManagedObjectContext *workMOC))block onComplete:(void(^)())complete;
@end
