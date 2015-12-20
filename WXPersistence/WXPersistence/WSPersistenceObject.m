//
//  WSPersistenceObject.m
//  WXPersistence
//
//  Created by 朱洪伟 on 15/11/12.
//  Copyright © 2015年 朱洪伟. All rights reserved.
//

#import "WSPersistenceObject.h"

#import "WSPersistenceObjectVersion.h"
#import "WSPersistenceObjectMateInfo.h"

@class WSPersistenceObjectMateInfo;
@class WSPersistenceObjectVersion;


@implementation WSPersistenceObject
{
    
@private
    NSInteger _pk;
}
@synthesize pk = _pk;

+ (Class)versionClass {
    return [WSPersistenceObjectVersion class];
}

+ (Class)mateInfoClass {
    return [WSPersistenceObjectMateInfo class];
}
+ (Class)customProperty
{
    return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        _pk = 0;
    }
    
    return self;
}


@end
