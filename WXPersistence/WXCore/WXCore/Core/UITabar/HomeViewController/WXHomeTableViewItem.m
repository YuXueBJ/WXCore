//
//  WXHomeTableViewItem.m
//  WXCore
//
//  Created by 朱洪伟 on 15/10/21.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXHomeTableViewItem.h"
#import "WXHomeTableViewObject.h"

@implementation WXHomeTableViewItem

- (instancetype)initWithObject:(NSDictionary*)json;
{
    self = [super init];
    if (self) {
        if (json) {
            self.home_Object=[[WXHomeTableViewObject alloc] initWithJson:json];
            //数据存储
//            [APPCONTEXT.campService saveCampistData:self.hotgirlData];
        }
    }
    return self;
}

-(instancetype)initWithReadJson:(WXHomeTableViewObject *)dbData
{
    self = [super init];
    if (self) {
        if (dbData) {
            self.home_Object=dbData;
        }
    }
    return self;
}

@end
