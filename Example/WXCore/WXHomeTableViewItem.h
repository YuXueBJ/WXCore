//
//  WXHomeTableViewItem.h
//  WXCore
//
//  Created by 朱洪伟 on 15/10/21.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXBaseTableView.h"
#import "WXCode.h"

@class WXHomeTableViewObject;
@interface WXHomeTableViewItem : WXTableViewItem
@property (nonatomic,strong)WXHomeTableViewObject * home_Object;
- (instancetype)initWithObject:(NSDictionary*)json;
-(instancetype)initWithReadJson:(WXHomeTableViewObject *)dbData;
@end
