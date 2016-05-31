//
//  WSPersistenceObjectProperty.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSPObjectPropColumnPair : NSObject

@property(nonatomic, retain) NSString *propName;
@property(nonatomic, retain) NSString *propType;
@property(nonatomic, retain) NSString *columnName;
@property(nonatomic, retain) NSString *columnType;

@end

@interface WSPersistenceObjectProperty : NSObject
@property(nonatomic, readonly) Class persistenceClass;
@property(nonatomic, readonly) NSString *className;
@property(nonatomic, readonly) NSString *tableName;
@property(nonatomic, readonly) NSString *updateSql;
@property(nonatomic, readonly) NSString *insertSql;
@property(nonatomic, readonly) NSArray *propColumnPairs;

- (id)initWithPersistenceClass:(Class)cls;

@end
