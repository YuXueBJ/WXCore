//
//  WXTableViewLoadMoreItem.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewItem.h"

@interface WXTableViewLoadMoreItem : WXTableViewItem

@property (nonatomic, assign)         BOOL	isLoading;
@property (nonatomic, retain) NSString		*title;

+ (WXTableViewLoadMoreItem *)itemWithTitle:(NSString *)title;

@end
