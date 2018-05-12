//
//  NSDictionary+Safe.h
//  djApp
//
//  Created by zhu hongwei on 3/22/14.
//  Copyright (c) 2014 dajie.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safe)

/**
 * @brief numberForKey:.
 *
 * @param  key 字典key
 *
 * @return 返回NSNumber 类型 value.
 */
- (NSNumber*) numberForKey:(NSString*)key;
/**
 * @brief stringForKey:.
 *
 * @param  key 字典key
 *
 * @return 返回NSString 类型 value.
 */
- (NSString*) stringForKey:(NSString*)key;
/**
 * @brief dicForKey:.
 *
 * @param  key 字典key
 *
 * @return 返回NSDictionary 类型 value.
 */
- (NSDictionary*) dicForKey:(NSString*)key;
/**
 * @brief arrayForKey:.
 *
 * @param  key 字典key
 *
 * @return 返回NSArray 类型 value.
 */
- (NSArray*) arrayForKey:(NSString*)key;
/**
 * @brief integerForKey:.
 *
 * @param  key 字典key
 *
 * @return 返回NSInteger 类型 value.
 */
- (NSInteger)integerForKey:(NSString*)key;

/**
 * @brief longForKey:.
 *
 * @param  key 字典key
 *
 * @return 返回long 类型 value.
 */
- (long long)longForKey:(NSString*)key;

/**
 * @brief numberForKey:defaultValue:.
 *
 * @param  key 字典key
 *
 * @param  value 字典value为空时默认返回值
 *
 * @return 返回NSNumber 类型 value.
 */
- (NSNumber*) numberForKey:(NSString*)key defaultValue:(NSNumber*)value;
- (NSString*) stringForKey:(NSString*)key defaultValue:(NSString*)value;
- (NSDictionary*) dicForKey:(NSString*)key defaultValue:(NSDictionary*)value;
- (NSArray*) arrayForKey:(NSString*)key defaultValue:(NSArray*)value;

@end
