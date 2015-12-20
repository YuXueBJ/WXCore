//
//  WSPersistenceContext.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class WSPersistenceObjectProperty;

@interface WSPersistenceContext : NSObject

@property(nonatomic, readonly)NSArray *tableObjectProps ;
@property(nonatomic, copy)NSString *filePath;

- (id)initWithDbFilePath:(NSString *)filePath;

- (void)registerClass:(Class)tableClass;

- (WSPersistenceObjectProperty*)property4TableClass:(Class)tableClass;

- (void)executeUpdateSql:(NSString *)updateSql;

- (void)executeUpdateSqls:(NSArray *)sqls;

- (void)executeInDatabase:(void (^)(FMDatabase *db))block;

- (void)executeInTransaction:(void (^)(FMDatabase *db))block;


@end
