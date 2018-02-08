//
//  WXTableViewSectionedDataSource.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewDataSource.h"


@interface WXTableViewSectionedDataSource : WXTableViewDataSource
{
    NSMutableArray *_sections;
}

@property (nonatomic, strong) NSMutableArray *sections;			// WXSectionObject对象数组
@property (nonatomic, assign) NSMutableArray *firstSectionItems;	// 返回第一个section的items数组


@end
