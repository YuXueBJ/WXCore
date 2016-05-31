//
//  WSPersistenceSequence.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSPersistenceContext;

@interface WSPersistenceSequence : NSObject
{
    WSPersistenceContext *_context;
}

- (id)initWithContext:(WSPersistenceContext *)context;

- (void)createSequenceTable;

- (void)addTableWithName:(NSString *)tableName defaultVersionCode:(NSInteger)code;

- (BOOL)isTableExisted:(NSString *)tableName;

- (NSInteger)versionCode4Table:(NSString *)tableName;

- (void)updateVersionCode4Table:(NSString *)tableName newVersionCode:(NSInteger)code;

- (NSInteger)makeNewSeq4Table:(NSString *)tableName;

@end
