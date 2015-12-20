//
//  WSPersistenceService.m
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "WSPersistenceService.h"
#import "WSPersistenceContext.h"
#import "WSPersistenceObject.h"
#import "WSPersistenceObjectProperty.h"
#import "WSPersistenceSequence.h"

@interface WSPersistenceService (Private)

- (id)instanceOfClassFromProp:(WSPersistenceObjectProperty *)prop tableRowInfo:(NSDictionary *)info;

@end

@implementation WSPersistenceService

@synthesize context = _context;

- (id)initWithContext:(WSPersistenceContext *)context {
    self = [super init];
    if (self) {
        _context = context;
    }
    
    return self;
}

- (void)dealloc {
    _context = nil;
}

- (void)saveOrUpdateObject:(WSPersistenceObject *)object {
    WSPersistenceObjectProperty *property = [_context property4TableClass:object.class];
    NSAssert(property != nil, @"保存未注册的class:%@", object);
    
    NSMutableArray *args = [NSMutableArray array];
    NSArray *pairs = property.propColumnPairs;
    for (NSUInteger i = 0; i < pairs.count; i++) {
        WSPObjectPropColumnPair *pair = [pairs objectAtIndex:i];
        if ([pair.propName isEqualToString:@"pk"])
            continue;
        
        id value = [object valueForKey:pair.propName];
        [args addObject:value == nil ? [NSNull null] : value];
    }
    
    if (object.pk > 0) {
        //更新
        [_context executeInDatabase:^(FMDatabase *db) {
            [args addObject:[NSNumber numberWithInteger:object.pk]];
            [db executeUpdate:property.updateSql withArgumentsInArray:args];
        }];
    }
    else {
        //插入
        [_context executeInDatabase:^(FMDatabase *db) {
            NSInteger pk = 0;
            WSPersistenceSequence *sequence = [[WSPersistenceSequence alloc] initWithContext:_context];
            pk = [sequence makeNewSeq4Table:property.tableName];
            sequence = nil;
            
            [args insertObject:[NSNumber numberWithInteger:pk] atIndex:0];
            [db executeUpdate:property.insertSql withArgumentsInArray:args];
            object.pk = pk;
        }];
    }
}

- (void)saveOrUpdateObjects:(NSArray *)objects {
    [_context executeInTransaction:^(FMDatabase *db) {
        for (WSPersistenceObject *obj in objects)
            [self saveOrUpdateObject:obj];
    }];
}


- (void)deleteObject:(WSPersistenceObject *)object {
    [self deleteObjectByPk:object.pk class:object.class];
    object.pk = 0;
}

- (void)deleteObjectByPk:(NSInteger)pk class:(Class)objectClass {
    WSPersistenceObjectProperty *property = [_context property4TableClass:objectClass];
    NSAssert(property != nil, @"删除未注册的class:%@", objectClass);
    [_context executeInDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE pk = ?", property.tableName],
         [NSNumber numberWithLong:pk]];
    }];
}

- (void)deleteObjectsByClass:(Class)class criteria:(NSString *)criteriaString, ... NS_REQUIRES_NIL_TERMINATION {
    //    WSPersistenceObjectProperty *property = [_context property4TableClass:class];
    //    NSAssert(property != nil, @"删除未注册的class:%@", class);
    //
    //    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@", property.tableName, criteriaString];
    //    va_list args;
    //    va_start(args, criteriaString);
    //
    //    [_context executeInDatabase:^(FMDatabase *db) {
    //        [db executeUpdate:sql
    //                    error:nil withArgumentsInArray:nil orDictionary:nil orVAList:args];
    //    }];
    //
    //    va_end(args);
    
    WSPersistenceObjectProperty *property = [_context property4TableClass:class];
    NSAssert(property != nil, @"删除未注册的class:%@", class);
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@", property.tableName, criteriaString];
    if (!criteriaString) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@", property.tableName];
    }
    
    va_list args;
    va_start(args, criteriaString);
    
    __block NSMutableArray *argesObjects = [NSMutableArray array];
    id obj = va_arg(args, id);
    while(obj)
    {
        if ((!obj) || ((NSNull *)obj == [NSNull null])) {
            [argesObjects addObject:obj];
            obj = va_arg(args,id);
        }else{
            break;
        }
    }
    
    [_context executeInDatabase:^(FMDatabase *db) {
//        [db executeUpdate:sql error:nil withArgumentsInArray:argesObjects orDictionary:nil orVAList:nil];
        [db executeQuery:sql withArgumentsInArray:argesObjects ];
    }];
    
    va_end(args);
}

- (void)deleteAllObject:(Class)objectClass {
    WSPersistenceObjectProperty *property = [_context property4TableClass:objectClass];
    NSAssert(property != nil, @"删除未注册的class:%@", objectClass);
    [_context executeInDatabase:^(FMDatabase *db) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@", property.tableName]];
    }];
}

- (NSInteger)countOfObject:(Class)objectClass {
    WSPersistenceObjectProperty *property = [_context property4TableClass:objectClass];
    NSAssert(property != nil, @"查询未注册的class:%@", objectClass);
    
    __block NSInteger count = 0;
    [_context executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT count(pk) FROM %@", property.tableName]];
        if ([rs next])
            count = [rs intForColumnIndex:0];
        [rs close];
    }];
    
    return count;
}

- (id)findObjectByPk:(NSInteger)pk class:(Class)objectClass {
    WSPersistenceObjectProperty *property = [_context property4TableClass:objectClass];
    NSAssert(property != nil, @"查询未注册的class:%@", objectClass);
    
    
    __block NSDictionary * tableRowInfo = nil;
    [_context executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE pk=?",
                                            property.tableName],
                           [NSNumber numberWithLong:pk]];
        if ([rs next]) {
            tableRowInfo = [rs resultDict];
        }
        [rs close];
    }];
    
    return [self instanceOfClassFromProp:property tableRowInfo:tableRowInfo];
}

- (id)findFirstObjectByClass:(Class)class criteria:(NSString *)criteriaString, ... NS_REQUIRES_NIL_TERMINATION {
    WSPersistenceObjectProperty *property = [_context property4TableClass:class];
    NSAssert(property != nil, @"查询未注册的class:%@", class);
    
    
    NSMutableArray *objects = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@", property.tableName, criteriaString];
    
    va_list args;
    va_start(args, criteriaString);
    __block  NSMutableArray *argsObjects = [NSMutableArray array];
    id obj = va_arg(args, id);
    while (obj) {
        if ((!obj) || ((NSNull *)obj == [NSNull null])) {
            [argsObjects addObject:obj];
            obj = va_arg(args,id);
        }else{
            break;
        }
    }
    va_end(args);
    
    [_context executeInDatabase:^(FMDatabase *db) {
        
        FMResultSet * rs = [db executeQuery:sql withArgumentsInArray:nil];
        
        while (rs && [rs next]) {
            NSDictionary * tableRowInfo = [rs resultDict];
            [objects addObject:[self instanceOfClassFromProp:property tableRowInfo:tableRowInfo]];
        }
        if (rs)
            [rs close];
    }];
    //    va_list args;
    //    va_start(args, criteriaString);
    //
    //    [_context executeInDatabase:^(FMDatabase *db) {
    //        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
    //        while (rs && [rs next]) {
    //            NSDictionary *tableRowInfo = [rs resultDict];
    //            [objects addObject:[self instanceOfClassFromProp:property tableRowInfo:tableRowInfo]];
    //        }
    //        if (rs)
    //            [rs close];
    //    }];
    //
    //    va_end(args);
    return objects.count > 0 ? [objects objectAtIndex:0] : nil;
    //    return objects;
}

- (NSArray *)findObjectsByClass:(Class)class criteria:(NSString *)criteriaString, ... NS_REQUIRES_NIL_TERMINATION{
    WSPersistenceObjectProperty *property = [_context property4TableClass:class];
    NSAssert(property != nil, @"查询未注册的class:%@", class);
    
    NSMutableArray *objects = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@", property.tableName, criteriaString];
    
    va_list args;
    va_start(args, criteriaString);
    __block  NSMutableArray *argsObjects = [NSMutableArray array];
    id obj = va_arg(args, id);
    while (obj) {
        if ((!obj) || ((NSNull *)obj == [NSNull null])) {
            [argsObjects addObject:obj];
            obj = va_arg(args,id);
        }else{
            break;
        }
    }
    va_end(args);
    
    [_context executeInDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:nil];
        FMResultSet * rs = [db executeQuery:sql withArgumentsInArray:nil];
        while (rs && [rs next]) {
            NSDictionary *tableRowInfo = [rs resultDict];
            [objects addObject:[self instanceOfClassFromProp:property tableRowInfo:tableRowInfo]];
        }
        if (rs)
            [rs close];
    }];
    
    va_end(args);
    
    //    va_list args;
    //    va_start(args, criteriaString);
    //
    //    [_context executeInDatabase:^(FMDatabase *db) {
    //        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:args];
    //        while (rs && [rs next]) {
    //            NSDictionary *tableRowInfo = [rs resultDict];
    //            [objects addObject:[self instanceOfClassFromProp:property tableRowInfo:tableRowInfo]];
    //        }
    //        if (rs)
    //            [rs close];
    //    }];
    //
    //    va_end(args);
    
    return objects;
}

- (NSArray *)allObjectsOfClass:(Class)class {
    WSPersistenceObjectProperty *property = [_context property4TableClass:class];
    NSAssert(property != nil, @"查询未注册的class:%@", class);
    
    NSMutableArray *objects = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@", property.tableName];
    
    [_context executeInDatabase:^(FMDatabase *db) {
//        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil orDictionary:nil orVAList:nil];
        FMResultSet * rs = [db executeQuery:sql withArgumentsInArray:nil];
        
        while (rs && [rs next]) {
            NSDictionary *tableRowInfo = [rs resultDict];
            [objects addObject:[self instanceOfClassFromProp:property tableRowInfo:tableRowInfo]];
        }
        if (rs)
            [rs close];
    }];
    
    return objects;
}

#pragma mark Private
- (id)instanceOfClassFromProp:(WSPersistenceObjectProperty *)prop tableRowInfo:(NSDictionary *)info {
    if (prop == nil || info == nil)
        return nil;
    
    id instance = [[prop.persistenceClass alloc] init];
    for (WSPObjectPropColumnPair *pair in  prop.propColumnPairs) {
        NSAssert([info objectForKey:pair.columnName] != nil,
                 @"pair's columname[%@] dont match the column name in db", pair.columnName);
        if (![[info objectForKey:pair.columnName] isKindOfClass:[NSNull class]]) {
            [instance setValue:[info objectForKey:pair.columnName] forKey:pair.propName];
        }
    }
    
    return instance;
}

- (NSInteger)countOfObject:(Class)objectClass criteria:(NSString *)criteriaString, ...NS_REQUIRES_NIL_TERMINATION
{
    WSPersistenceObjectProperty *property = [_context property4TableClass:objectClass];
    NSAssert(property != nil, @"查询未注册的class:%@", objectClass);
    
    __block NSInteger count = 0;
    [_context executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT count(pk) FROM %@ %@", property.tableName,criteriaString]];
        if ([rs next])
            count = [rs intForColumnIndex:0];
        [rs close];
    }];
    
    return count;
}


@end
