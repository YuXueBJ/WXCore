//
//  WXTableViewItem.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXTableViewItem : NSObject

@property (nonatomic, assign) float cellHeight;	// 缓存cell的高度,主要用于高度可变的cell

@property (nonatomic, retain) id userInfo;		// 用户数据

@property (nonatomic, assign) BOOL isneedrefash;
@end
