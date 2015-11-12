//
//  WSPersistenceObject.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPersistenceObjectProperty.h"

@interface WSPersistenceObject : NSObject
@property(nonatomic, assign) NSInteger pk;
//@property(nonatomic, assign, getter = isCascade) BOOL cascade;

+ (Class)mateInfoClass;

+ (Class)versionClass;
+ (Class)customProperty;

@end
