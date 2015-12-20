//
//  WSPersistenceSequence.m
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "WSPersistenceSequence.h"
#import "WSPersistenceContext.h"
#import "FMDatabase.h"

@implementation WSPersistenceSequence

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

- (void)createSequenceTable {
    
    [_context executeInDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SQLITESEQUENCE (name TEXT PRIMARY KEY, seq INTEGER,version INTEGER)"];
        
        FMResultSet *rs = [db executeQuery:@"pragma table_info(SQLITESEQUENCE)"];
        NSMutableDictionary *tableInfo = [NSMutableDictionary dictionary];
        
        while ([rs next]) {
            NSString *colName = [rs stringForColumn:@"name"];
            NSString *colType = [rs stringForColumn:@"type"];
            [tableInfo setObject:colType forKey:colName];
        }
        
        [rs close];
        
        if (![tableInfo objectForKey:@"version"]) {
            [db executeUpdate:@"alter table SQLITESEQUENCE add column version INTEGER default 0"];
        }
    }];
}

- (void)addTableWithName:(NSString *)tableName defaultVersionCode:(NSInteger)code {
    
    [_context executeInDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT OR IGNORE INTO SQLITESEQUENCE (name,seq,version) VALUES (?,?,?)",
         tableName,
         [NSNumber numberWithInt:1],
         [NSNumber numberWithInt:(int)code]];
    }];
}

- (BOOL)isTableExisted:(NSString *)tableName {
    __block BOOL exist = NO;
    
    [_context executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT SEQ FROM SQLITESEQUENCE WHERE NAME=?", tableName];
        
        if ([rs next]) {
            exist = YES;
        }
        
        [rs close];
    }];
    
    return exist;
}

- (NSInteger)versionCode4Table:(NSString *)tableName {
    __block NSInteger versionCode = 0;
    [_context executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT VERSION FROM SQLITESEQUENCE WHERE NAME=?", tableName];
        if ([rs next]) {
            versionCode = [rs intForColumnIndex:0];
        }
        
        [rs close];
    }];
    
    return versionCode;
}

- (void)updateVersionCode4Table:(NSString *)tableName newVersionCode:(NSInteger)code {
    [_context executeInDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE SQLITESEQUENCE set version=? WHERE name=?",
         [NSNumber numberWithInteger:code],
         tableName];
    }];
}

- (NSInteger)makeNewSeq4Table:(NSString *)tableName {
    __block NSInteger pk = 0;
    
    [_context executeInDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT seq FROM SQLITESEQUENCE WHERE NAME=?", tableName];
        if ([rs next]) {
            pk = [rs intForColumnIndex:0];
        }
        [rs close];
        
        pk++;
        
        [db executeUpdate:@"UPDATE SQLITESEQUENCE set seq=? WHERE name=?",
         [NSNumber numberWithInteger:pk],
         tableName];
    }];
    
    return pk;
}
@end
