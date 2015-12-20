//
//  NSObjectAddition.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 www.zhwios.com. All rights reserved.
//


#import <Foundation/Foundation.h>

#if (TARGET_OS_IPHONE)
/*!
 On the iPhone NSObject does not provide the className method.
 */
@interface NSObject(ClassName)
- (NSString *)className;
+ (NSString *)className;
@end
#endif

@interface NSObject (Description)


- (NSString *)rsDescription;

@end