//
//  WXTableViewSectionObject.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewSectionObject.h"

@implementation WXTableViewSectionObject
@synthesize letter = _letter;
@synthesize title = _title;
@synthesize userInfo = _userInfo;
@synthesize items = _items;
@synthesize footerTitle = _footerTitle;

// 初始化
- (NSMutableArray *)items
{
    if (!_items){
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}
@end
