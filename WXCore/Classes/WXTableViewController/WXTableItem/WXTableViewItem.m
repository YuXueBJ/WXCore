//
//  WXTableViewItem.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewItem.h"

@implementation WXTableViewItem
@synthesize cellHeight = _cellHeight;
@synthesize userInfo = _userInfo;
@synthesize isneedrefash;

-(id)init{
    self = [super init];
    if (self) {
        self.isneedrefash = NO;
    }
    return self;
}

- (float)cellHeight {
    return ceilf(_cellHeight);
}

@end
