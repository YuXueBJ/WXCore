//
//  AppContext.m
//  TestPersistence
//
//  Created by 朱洪伟 on 15/12/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "AppContext.h"

@implementation AppContext

static AppContext * dataEngineInstance=nil;
+ (AppContext*)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataEngineInstance=[[[self class] alloc] init];
    });
    return dataEngineInstance;
}
+ (instancetype)allocWithZone:(NSZone *)zone;
{
    if(dataEngineInstance==nil)
    {
        dataEngineInstance=[super allocWithZone:zone];
    }
    return dataEngineInstance;
}
-(instancetype)copyWithZone:(NSZone *)zone
{
    return dataEngineInstance;
}
- (instancetype)init
{
    @synchronized(dataEngineInstance) {
        return dataEngineInstance;
    }
    return dataEngineInstance;
}

- (void)createDatabaseFiled
{
    NSString * userId = @"2015_007";
    NSString * version = @"2015_007";
    
    // 根据用户id创建路径
    ////////////////////////////////////////////////////////////////////////
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    
    NSString *databaseFolderPath = [documentPath stringByAppendingPathComponent:@"USERINFO"];
    
    NSLog(@"changeDBDir by userId : %@",userId);
    databaseFolderPath = [databaseFolderPath stringByAppendingPathComponent:userId];
    databaseFolderPath = [databaseFolderPath stringByAppendingPathComponent:@"DATABASE"];
    
    //删除用户缓存数据
    if ([[NSFileManager defaultManager] fileExistsAtPath:databaseFolderPath]) {
        NSNumber *isfirstLaunching = [[NSUserDefaults standardUserDefaults] objectForKey:version];
        if (!isfirstLaunching || isfirstLaunching.intValue == 0) {
            BOOL removeSuccess = [[NSFileManager defaultManager] removeItemAtPath:databaseFolderPath error:nil];
            NSAssert(removeSuccess, @"remove folder failed,%@", databaseFolderPath);
            NSLog(@"removeSuccess==%d",removeSuccess);
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:version];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:version];
    }
    
    
    BOOL createSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:databaseFolderPath
                                                   withIntermediateDirectories:YES attributes:nil error:nil];
    NSAssert(createSuccess, @"create folder failed,%@", databaseFolderPath);
    NSLog(@"createSuccess==%d",createSuccess);
    NSString *databaseFilePath = [databaseFolderPath stringByAppendingPathComponent:@"homeDataSave.sqlite"];
    _homeDataPersistenceContext = [[WSPersistenceContext alloc] initWithDbFilePath:databaseFilePath];
    
    [self homeDataSave];
}

- (HomeDataSave*)homeDataSave {
    if (!_homeDataSave) {
        _homeDataSave = [[HomeDataSave alloc] initWithContext:self.homeDataPersistenceContext];
    }
    return _homeDataSave;
}

@end
