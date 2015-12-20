//
//  WSPersistenceObjectProperty.m
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "WSPersistenceObjectProperty.h"
#import <objc/runtime.h>
#import "NSObjectAddition.h"
#import "WSPersistenceUtil.h"
#import "WSPersistenceObjectMateInfo.h"
#import "WSPersistenceObject.h"

@implementation WSPObjectPropColumnPair {
@private
    NSString *_propName;
    NSString *_propType;
    NSString *_columnName;
    NSString *_columnType;
}

@synthesize propName = _propName;
@synthesize propType = _propType;
@synthesize columnName = _columnName;
@synthesize columnType = _columnType;

- (void)dealloc {
    _propName = nil;
    _propType = nil;
    _columnName = nil;
    _columnType = nil;
}

- (void)setColumnName:(NSString *)aColumnName {
    _columnName = nil;
    if (aColumnName != nil)
        _columnName = [[aColumnName lowercaseString] copy];
    else
        _columnName = nil;
}

#pragma mark Override
- (NSString *)description {
    NSMutableString *desc = [NSMutableString string];
    [desc appendString:[super description]];
    [desc appendFormat:@",propName:%@", self.propName];
    [desc appendFormat:@",propType:%@", self.propType];
    [desc appendFormat:@",columnName:%@", self.columnName];
    [desc appendFormat:@",columnType:%@", self.columnType];
    return desc;
}

@end


@interface WSPersistenceObjectProperty (Private)

- (NSArray *)createPropColumnPairsWithClass:(Class)cls;

- (NSString *)createUpdateSql;

- (NSString *)createInsertSql;

- (NSString *)getPropertyName:(objc_property_t)prop;

- (NSString *)getPropertyAttrs:(objc_property_t)prop;

- (NSString *)getPropertyType:(objc_property_t)prop;

- (BOOL)shouldDismissProp:(objc_property_t)prop;

@end


@implementation WSPersistenceObjectProperty
{
    
@private
    NSString *_className;
    NSString *_tableName;
    NSString *_updateSql;
    NSString *_insertSql;
    NSArray *_propColumnPairs;
    Class _persistenceClass;
    Class _mateInfoClass;
}

@synthesize persistenceClass = _persistenceClass;
@synthesize className = _className;
@synthesize tableName = _tableName;
@synthesize updateSql = _updateSql;
@synthesize insertSql = _insertSql;
@synthesize propColumnPairs = _propColumnPairs;

- (id)initWithPersistenceClass:(Class)cls {
    self = [super init];
    if (self) {
        _persistenceClass = cls;
        _mateInfoClass = [_persistenceClass mateInfoClass];
        
        _className = [cls className];
        _tableName = [WSPersistenceUtil convert2DatabaseNameFrom:_className];
        _propColumnPairs = [self createPropColumnPairsWithClass:cls];
        _updateSql = [self createUpdateSql];
        _insertSql = [self createInsertSql];
    }
    return self;
}

- (void)dealloc {
    _className = nil;
    _tableName = nil;
    _updateSql = nil;
    _insertSql = nil;
    _propColumnPairs = nil;
}

#pragma mark Override
- (NSString *)description {
    NSMutableString *desc = [NSMutableString string];
    [desc appendString:[super description]];
    [desc appendFormat:@",persistanceClass:%@", self.persistenceClass];
    [desc appendFormat:@",className:%@", self.className];
    [desc appendFormat:@",tableName:%@", self.tableName];
    [desc appendFormat:@",updateSql:%@", self.updateSql];
    [desc appendFormat:@",insertSql:%@", self.insertSql];
    [desc appendFormat:@",propColumnPairs:%@", self.propColumnPairs];
    return desc;
}


#pragma mark Private
+ (NSString *)columnType4PropType:(NSString *)propType {
    //数字
    if ([propType isEqualToString:@"i"] || // int
        [propType isEqualToString:@"I"] || // unsigned int
        [propType isEqualToString:@"l"] || // long
        [propType isEqualToString:@"L"] || // usigned long
        [propType isEqualToString:@"q"] || // long long
        [propType isEqualToString:@"Q"] || // unsigned long long
        [propType isEqualToString:@"s"] || // short
        [propType isEqualToString:@"S"] || // unsigned short
        [propType isEqualToString:@"B"] || // bool or _Bool
        [propType isEqualToString:@"c"] || // char
        [propType isEqualToString:@"C"])   // unsigned char
    {
        return @"INTEGER";
    }
    else if ([propType isEqualToString:@"f"] || // float
             [propType isEqualToString:@"d"])  // double
    {
        return @"REAL";
    }
    else if ([propType hasPrefix:@"@"] && propType.length > 3) {
        NSString *className = [propType substringWithRange:NSMakeRange(2, [propType length] - 3)];
        
        //NSNumber类型的当作REAL
        if ([className isEqualToString:@"NSNumber"])
            return @"REAL";
        
        //字符串
        if ([className isEqualToString:@"NSString"])
            return @"TEXT";
    }
    
    //忽略属性
    return nil;
}

//- (RSPersistenceObjectMateInfo *)createMateInfo {
//    return [_persistenceClass mateInfo];
//}

- (NSArray *)createPropColumnPairsWithClass:(Class)cls {
    NSMutableArray *pairs;
    if (cls != [NSObject class])
        pairs = (NSMutableArray *) [self createPropColumnPairsWithClass:cls.superclass];
    else
        return [NSMutableArray array];
    
    unsigned int propsCount;
    objc_property_t *propList = class_copyPropertyList(cls, &propsCount);
    
    for (int i = 0; i < propsCount; i++) {
        objc_property_t oneProp = propList[i];
        
        if ([self shouldDismissProp:oneProp])
            continue;
        
        WSPObjectPropColumnPair *pair = [[WSPObjectPropColumnPair alloc] init];
        pair.propName = [self getPropertyName:oneProp];
        pair.propType = [self getPropertyType:oneProp];
        pair.columnName = [WSPersistenceUtil convert2DatabaseNameFrom:pair.propName];
        pair.columnType = [WSPersistenceObjectProperty columnType4PropType:pair.propType];
        [pairs addObject:pair];
    }
    
    if (propList)
        free(propList);
    
    return pairs;
}

- (NSString *)createUpdateSql {
    NSMutableString *updateSql = [NSMutableString stringWithCapacity:500];
    
    [updateSql appendFormat:@"UPDATE %@ set ", self.tableName];
    
    BOOL first = YES;
    for (int i = 0; i < _propColumnPairs.count; i++) {
        WSPObjectPropColumnPair *pair = [_propColumnPairs objectAtIndex:(NSUInteger) i];
        
        if ([@"pk" isEqualToString:pair.propName])
            continue;
        
        if (!first)
            [updateSql appendString:@","];
        
        [updateSql appendFormat:@"%@ = ?", pair.columnName];
        first = NO;
    }
    
    [updateSql appendString:@" WHERE pk = ?"];
    return updateSql;
}

- (NSString *)createInsertSql {
    NSMutableString *createSql = [NSMutableString stringWithCapacity:500];
    
    [createSql appendFormat:@"INSERT INTO %@(pk", self.tableName];
    for (int i = 0; i < _propColumnPairs.count; i++) {
        WSPObjectPropColumnPair *pair = [_propColumnPairs objectAtIndex:(NSUInteger) i];
        if ([@"pk" isEqualToString:pair.propName])
            continue;
        
        [createSql appendFormat:@",%@", pair.columnName];
    }
    
    [createSql appendString:@") VALUES(? "];
    
    for (int i = 0; i < _propColumnPairs.count - 1; i++)
        [createSql appendString:@",?"];
    
    [createSql appendString:@")"];
    
    return createSql;
}

- (NSString *)getPropertyName:(objc_property_t)prop {
    return [NSString stringWithUTF8String:property_getName(prop)];
}

- (NSString *)getPropertyAttrs:(objc_property_t)prop {
    return [NSString stringWithUTF8String:property_getAttributes(prop)];
}

- (NSString *)getPropertyType:(objc_property_t)prop {
    NSString *attrs = [self getPropertyAttrs:prop];
    NSArray *attrParts = [attrs componentsSeparatedByString:@","];
    
    if (attrParts == nil || attrParts.count <= 0)
        return nil;
    
    return [[attrParts objectAtIndex:0] substringFromIndex:1];
}

- (BOOL)shouldDismissProp:(objc_property_t)prop {
    NSString *propName = [self getPropertyName:prop];
    NSString *attrs = [self getPropertyAttrs:prop];
    NSString *propType = [self getPropertyType:prop];
    
    //不能识别的属性类型
    if (propType == nil)
        return YES;
    
    //非NSNumber NSString的类需要忽略
    if ([propType hasPrefix:@"@"]) {
        if (propType.length <= 3)
            return YES;
        
        NSString *className = [propType substringWithRange:NSMakeRange(2, [propType length] - 3)];
        if (![className isEqualToString:@"NSNumber"] &&
            ![className isEqualToString:@"NSString"])
            return YES;
    }
    
    
    //只读的不行
    if ([attrs rangeOfString:@",R,"].location != NSNotFound)
        return YES;
    
    //在忽略列表中的也不行
    if (_mateInfoClass &&
        [_mateInfoClass transientProps] &&
        [[_mateInfoClass transientProps] indexOfObject:propName] != NSNotFound)
        return YES;
    
    return NO;
}


@end
