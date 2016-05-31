//
//  RSPersistenceObjectVersion.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSPersistenceContext;

@interface WSPersistenceObjectVersion : NSObject

+ (NSInteger)versionCode;

+ (void)beginUpgradeFromVersion:(NSInteger)version context:(WSPersistenceContext *)context;

+ (void)endUpgradeFromVersion:(NSInteger)version context:(WSPersistenceContext *)context;


@end
