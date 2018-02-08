//
//  NSObjectAddition.h
//  WXCore
//
//  Created by 朱洪伟 on 15/10/22.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXBaseTableView.h"

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
