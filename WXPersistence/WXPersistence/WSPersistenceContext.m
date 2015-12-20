//
//  WSPersistenceContext.m
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "WSPersistenceContext.h"
#import "FMDatabase.h"
#import "WSPersistenceObjectProperty.h"
#import "WSPersistenceSequence.h"
#import "WSPersistenceTableUpgrader.h"
#import "WSPersistenceObject.h"


@interface WSPersistenceContext (Private)

- (void)initDbPoolWithFile:(NSString *)dbFilePath;

- (void)createSequenceTable;

- (FMDatabase *)currentDatabase;

- (void)executeLocked:(void (^)(void))aBlock;

@end

@implementation WSPersistenceContext
{
@private
    FMDatabasePool *_dbPool;
    NSMutableArray *_tableObjectProps;
    
    dispatch_queue_t _lockQueue;
    NSMutableDictionary *_threadDbInfo;
    NSUInteger _threadIndex;
    NSLock *_transactionLock;
}
@synthesize tableObjectProps = _tableObjectProps;
@synthesize filePath = _filePath;

- (id)initWithDbFilePath:(NSString *)filePath {
    self = [super init];
    
    if (self) {
        self.filePath = filePath;
        _tableObjectProps = [NSMutableArray array];
        _threadDbInfo = [NSMutableDictionary dictionary];
        _threadIndex = 0;
        _transactionLock = [[NSLock alloc] init];
        _lockQueue = dispatch_queue_create([[NSString stringWithFormat:@"WSPersistenceContext.%@", self] UTF8String],
                                           NULL);
        
        [self initDbPoolWithFile:filePath];
        [self createSequenceTable];
    }
    
    return self;
}

- (void)dealloc {
    _dbPool = nil;
    _tableObjectProps =nil;
    _threadDbInfo =nil;
    _transactionLock =nil;
    _filePath =nil;
}

- (void)registerClass:(Class)tableClass {
    //已经注册了
    if ([self property4TableClass:tableClass])
        return;
    
    WSPersistenceObjectProperty *property = nil;
    Class customeProperty = [tableClass customProperty];
    if (customeProperty != nil) {
        property = [[customeProperty alloc] initWithPersistenceClass:tableClass];
    }
    else {
        property = [[WSPersistenceObjectProperty alloc] initWithPersistenceClass:tableClass];
    }
    [self executeLocked:^() {
        [_tableObjectProps addObject:property];
    }];
    
//    property =nil;
    
    //创建table or 升级
    WSPersistenceTableUpgrader *upgrader = [[WSPersistenceTableUpgrader alloc] initWithContext:self
                                                                                      property:property];
    [upgrader upgrade];
    upgrader = nil;
    
}

- (WSPersistenceObjectProperty *)property4TableClass:(Class)tableClass {
    __block WSPersistenceObjectProperty *property = nil;
    [self executeLocked:^() {
        for (WSPersistenceObjectProperty *propObj in _tableObjectProps) {
            if (propObj.persistenceClass == tableClass) {
                property = propObj;
                break;
            }
        }
    }];
    
    return property;
}

- (void)executeUpdateSql:(NSString *)updateSql {
    [self executeInDatabase:^(FMDatabase *db) {
        [db executeUpdate:updateSql];
    }];
}

- (void)executeUpdateSqls:(NSArray *)sqls {
    if (sqls == nil || sqls.count <= 0)
        return;
    
    [self executeInDatabase:^(FMDatabase *db) {
        for (int i = 0; i < sqls.count; i++) {
            [db executeUpdate:[sqls objectAtIndex:(NSUInteger) i]];
        }
    }];
}

- (void)executeInDatabase:(void (^)(FMDatabase *))block {
    FMDatabase *curDb = [self currentDatabase];
    if (curDb) {
        block(curDb);
    } else {
        [_dbPool inDatabase:^(FMDatabase *db) {
            block(db);
        }];
    }
}

- (void)executeInTransaction:(void (^)(FMDatabase *))block {
    [_transactionLock lock];
    
    [_dbPool inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
        [self executeLocked:^{
            _threadIndex++;
            NSString *threadName = [NSString stringWithFormat:@"%ld", _threadIndex];
            [[NSThread currentThread] setName:threadName];
            [_threadDbInfo setObject:db forKey:threadName];
        }];
        
        block(db);
        
        [self executeLocked:^{
            NSString *threadName = [NSThread currentThread].name;
            if (threadName)
                [_threadDbInfo removeObjectForKey:threadName];
        }];
    }];
    
    [_transactionLock unlock];
}

#pragma mark Private
- (void)initDbPoolWithFile:(NSString *)dbFilePath {
    _dbPool = [[FMDatabasePool alloc] initWithPath:dbFilePath];
    _dbPool.maximumNumberOfDatabasesToCreate = 10;
}

- (void)createSequenceTable {
    WSPersistenceSequence *sequence = [[WSPersistenceSequence alloc] initWithContext:self];
    [sequence createSequenceTable];
}

- (FMDatabase *)currentDatabase {
    NSString *threadName = [NSThread currentThread].name;
    if (!threadName)
        return nil;
    else
        return [_threadDbInfo objectForKey:threadName];
}

- (void)executeLocked:(void (^)(void))aBlock {
    dispatch_sync(_lockQueue, aBlock);
}
@end
