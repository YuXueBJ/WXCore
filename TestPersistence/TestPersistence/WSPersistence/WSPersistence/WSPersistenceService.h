//
//  WSPersistenceService.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@class WSPersistenceContext;
@class WSPersistenceObject;

@interface WSPersistenceService : NSObject
{
    WSPersistenceContext *_context;
}
@property (nonatomic, retain, readonly) WSPersistenceContext* context;

- (id)initWithContext:(WSPersistenceContext *)context;

- (void)saveOrUpdateObject:(WSPersistenceObject *)object;

- (void)saveOrUpdateObjects:(NSArray *)objects;

- (void)deleteObject:(WSPersistenceObject *)object;

- (void)deleteObjectByPk:(NSInteger)pk class:(Class)objectClass;

- (void)deleteObjectsByClass:(Class)cls criteria:(NSString *)criteriaString, ...;

- (void)deleteAllObject:(Class)objectClass;

- (NSInteger)countOfObject:(Class)objectClass;

- (id)findObjectByPk:(NSInteger)pk class:(Class)objectClass;

- (id)findFirstObjectByClass:(Class)cls criteria:(NSString *)criteriaString, ...;

- (NSArray *)findObjectsByClass:(Class)cls criteria:(NSString *)criteriaString, ...;

- (NSArray *)allObjectsOfClass:(Class)cls;

- (NSInteger)countOfObject:(Class)objectClass criteria:(NSString *)criteriaString, ...;

@end
