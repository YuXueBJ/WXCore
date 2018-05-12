//
//  WXTableViewLoadMoreItem.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewLoadMoreItem.h"
#import "WXCode.h"

@implementation WXTableViewLoadMoreItem

@synthesize isLoading = _isLoading;
@synthesize title = _title;

+ (WXTableViewLoadMoreItem *)itemWithTitle:(NSString *)title
{
    WXTableViewLoadMoreItem *item = [[WXTableViewLoadMoreItem alloc] init];
    item.title = title;
    return item;
}
-(void)setTitle:(NSString *)title{
    if (_title) {
        _title = nil;
    }
    _title = [NSString stringWithString:NSLocalizedStringFromTable(@"载入更多...", RS_CURRENT_LANGUAGE_TABLE, nil)] ;
    
}
- (void)dealloc{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end
