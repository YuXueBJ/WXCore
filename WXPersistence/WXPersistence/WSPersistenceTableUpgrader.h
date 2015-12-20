//
//  WSPersistenceTableUpgrader.h
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WSPersistenceContext;
@class WSPersistenceObjectProperty;

@interface WSPersistenceTableUpgrader : NSObject


- (id)initWithContext:(WSPersistenceContext *)context property:(WSPersistenceObjectProperty *)property;

- (void)upgrade;

@end
