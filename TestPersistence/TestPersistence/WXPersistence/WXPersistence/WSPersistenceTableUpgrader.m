//
//  WSPersistenceTableUpgrader.m
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "WSPersistenceTableUpgrader.h"

#import "WSPersistenceSequence.h"
#import "WSPersistenceObjectVersion.h"
#import "WSPersistenceObjectMateInfo.h"
#import "WSPersistenceUtil.h"
#import "WSPersistenceObjectProperty.h"
#import "FMDatabase.h"
#import "WSPersistenceObject.h"
#import "WSPersistenceContext.h"

@interface WSPersistenceTableUpgrader (Private)

- (NSDictionary *)tableInfo;

- (void)createIndices;

- (void)createTable;

- (BOOL)needUpgrade;

- (void)doUpgrade;

- (void)notifyPreparedUpgrade;

- (void)notifyUpgradeCompleted;

@end

@interface WSPersistenceTableUpgrader (Sqls)
- (NSString *)createTableSql;

- (NSArray *)upgradeSqls;

- (NSArray *)indexSqls;
@end


@implementation WSPersistenceTableUpgrader

{
@private
    WSPersistenceContext *_context;
    WSPersistenceObjectProperty *_property;
    WSPersistenceSequence *_sequence;
    
    Class _mateInfoClass;
    Class _tableVersionClass;
    
    BOOL _isTableExisted;
    
    NSInteger _oldVersionCode;
    NSInteger _currentVersionCode;
}


- (id)initWithContext:(WSPersistenceContext *)context property:(WSPersistenceObjectProperty *)property {
    self = [super init];
    if (self) {
        _context = context;
        _property = property;
        _sequence = [[WSPersistenceSequence alloc] initWithContext:context];
        _mateInfoClass = [_property.persistenceClass mateInfoClass];
        _tableVersionClass = [_property.persistenceClass versionClass];
    }
    
    return self;
}

- (void)dealloc {
    _context = nil;
    _property =nil;
    _sequence =nil;
}

- (void)upgrade {
    [self createTable];
    [self doUpgrade];
    [self createIndices];
}

#pragma mark Private
- (NSDictionary *)tableInfo {
    __block NSString *tableName = _property.tableName;
    __block NSMutableDictionary *tableInfo = [NSMutableDictionary dictionary];
    
    [_context executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"pragma table_info(%@)", tableName]];
        
        while ([rs next]) {
            NSString *colName = [rs stringForColumn:@"name"];
            NSString *colType = [rs stringForColumn:@"type"];
            [tableInfo setObject:colType forKey:colName];
        }
        
        [rs close];
    }];
    
    return tableInfo;
}

- (void)createIndices {
    [_context executeUpdateSqls:[self indexSqls]];
}

- (void)createTable {
    _isTableExisted = [_sequence isTableExisted:_property.tableName];
    if (!_isTableExisted) {
        NSInteger versionCode = _tableVersionClass == nil ? 0 : [_tableVersionClass versionCode];
        [_sequence addTableWithName:_property.tableName defaultVersionCode:versionCode];
    }
    
    [_context executeUpdateSql:[self createTableSql]];
}

- (BOOL)needUpgrade {
    if (!_isTableExisted)
        return NO;
    
    _oldVersionCode = [_sequence versionCode4Table:_property.tableName];
    _currentVersionCode = _tableVersionClass == nil ? 0 : [_tableVersionClass versionCode];
    
    return _currentVersionCode >= _oldVersionCode;
}

- (void)doUpgrade {
    if ([self needUpgrade]) {
        [self notifyPreparedUpgrade];
        [_context executeUpdateSqls:[self upgradeSqls]];
        if (_currentVersionCode > _oldVersionCode)
            [_sequence updateVersionCode4Table:_property.tableName newVersionCode:_currentVersionCode];
        [self notifyUpgradeCompleted];
    }
}

- (void)notifyPreparedUpgrade {
    if (_tableVersionClass && _currentVersionCode > _oldVersionCode)
        [_tableVersionClass beginUpgradeFromVersion:_oldVersionCode context:_context];
}

- (void)notifyUpgradeCompleted {
    if (_tableVersionClass && _currentVersionCode > _oldVersionCode)
        [_tableVersionClass endUpgradeFromVersion:_oldVersionCode context:_context];
}

#pragma mark Sqls
- (NSString *)createTableSql {
    NSMutableString *sql = [NSMutableString string];
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ (pk INTEGER PRIMARY KEY", _property.tableName];
    
    NSArray *pairs = _property.propColumnPairs;
    for (WSPObjectPropColumnPair *pair in pairs) {
        if ([pair.propName isEqualToString:@"pk"])
            continue;
        
        [sql appendFormat:@",%@ %@", pair.columnName, pair.columnType];
    }
    
    [sql appendString:@")"];
    return sql;
}


- (NSArray *)upgradeSqls {
    NSMutableArray *result = [NSMutableArray array];
    
    NSString *tableName = _property.tableName;
    NSArray *pairs = _property.propColumnPairs;
    
    
    [_context executeInDatabase:^(FMDatabase *db) {
        NSDictionary *tableInfo = [self tableInfo];
        
        for (WSPObjectPropColumnPair *pair in pairs) {
            NSString *columnName = pair.columnName;
            NSString *columnType = pair.columnType;
            
            if ([tableInfo objectForKey:columnName]) {
                if ([columnType compare:[tableInfo objectForKey:columnName] options:NSCaseInsensitiveSearch] == 0)
                    continue;
                // 更新列类型,额，sqlite不支持呀
                // 解决办法:drop table,重新创建,但是数据就丢了呀,还是不更新了
                // TODO 添加日志,严重, 数据类型不一致
                NSLog(@"数据库中的字段类型与程序中不一致, tableName:%@, columnName:%@, columnType in app:%@, columnType in db:%@ ",
                      tableName,
                      columnName,
                      columnType,
                      [tableInfo objectForKey:columnName]);
            } else {
                [result addObject:[NSString stringWithFormat:@"alter table %@ add column %@ %@",
                                   tableName,
                                   columnName,
                                   columnType
                                   ]];
            }
        }
    }];
    
    return result;
}

- (NSArray *)indexSqls {
    NSMutableArray *result = [NSMutableArray array];
    
    [_context executeInDatabase:^(FMDatabase *db) {
        NSString *tableName = _property.tableName;
        // 创建索引
        NSArray *theIndices = _mateInfoClass == nil ? nil : [_mateInfoClass indices];
        
        if (theIndices == nil || theIndices.count <= 0)
            return;
        
        for (NSArray *oneIndex in theIndices) {
            // 索引名
            NSMutableString *indexName = [NSMutableString stringWithString:tableName];
            // 索引限制条件
            NSMutableString *fieldCondition = [NSMutableString string];
            BOOL first = YES;
            
            for (NSString *oneField in oneIndex) {
                NSString *columnName = [WSPersistenceUtil convert2DatabaseNameFrom:oneField];
                [indexName appendFormat:@"_%@", columnName];
                
                if (first)
                    first = NO;
                else
                    [fieldCondition appendString:@", "];
                
                [fieldCondition appendString:columnName];
            }
            
            [result addObject:[NSString stringWithFormat:@"create index if not exists %@ on %@ (%@)",
                               indexName,
                               tableName,
                               fieldCondition]];
        }
    }];
    
    return result;
}

@end
