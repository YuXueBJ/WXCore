//
//  WXCoreDataManager.m
//  WXCore
//
//  Created by 朱洪伟 on 15/6/30.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXCoreDataManager.h"
#import "WXUtility.h"


static WXCoreDataManager *g_coredataManager = nil;

@interface WXCoreDataManager(){
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContextMainThread;
    NSManagedObjectContext *_managedObjectContextRoot;
    NSManagedObjectContext *_managedObjectContextPersistWork;
}
@end
@implementation WXCoreDataManager
+ (NSString *)currentUid{
//    if ([PMMainUser mainUser].userId > 0) {
//        return [NSString stringWithFormat:@"%06lld", [PMMainUser mainUser].userId];
//    }
    return nil;
}
+ (NSString *)randCachePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imageFileCache = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"imageCache"];
    
    srand((unsigned)time(NULL));
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageFileCache]){
        BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:imageFileCache
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:NULL];
        if (!ret)
            return nil;
    }
    
    return [imageFileCache stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp-%lld-%d", [[NSNumber numberWithLongLong:[[NSDate date] timeIntervalSince1970]*1000] longLongValue], rand()]];
}

+ (NSString*)soundPathForCurrentUser:(long long)soundId sendByMe:(BOOL)sendByMe
{
    NSString* doc = [WXUtility documentPath];
//    NSString* user = [NSString stringWithFormat:@"%@/%lld", doc, [PMMainUser mainUser].userId];
    NSString* user = [NSString stringWithFormat:@"%@/%d", doc, 1];

    NSString* soundPath = [NSString stringWithFormat:@"%@/sound", user];
    if (!sendByMe) {
        soundPath = [NSString stringWithFormat:@"%@/f", soundPath];
    }
    [WXUtility createPersistantPath:soundPath];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%lld.mp3", soundPath, soundId];
    
    return filePath;
}

+ (NSString*)imagePathForCurrentUser:(long long)imageId
{
    NSString* doc = [WXUtility documentPath];
    NSString* user = [NSString stringWithFormat:@"%@/%f", doc, 1.0];
    [WXUtility createPersistantPath:user];
    NSString* imgPath = [NSString stringWithFormat:@"%@/image", user];
    [WXUtility createPersistantPath:imgPath];
    
    NSString* file = [NSString stringWithFormat:@"%@/%lld", imgPath, imageId];
    return file;
}

@end
