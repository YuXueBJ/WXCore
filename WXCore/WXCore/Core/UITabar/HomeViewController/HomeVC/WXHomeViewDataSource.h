//
//  WXHomeViewDataSource.h
//  WXCore
//
//  Created by 朱洪伟 on 15/10/21.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXBaseTableView.h"

@interface WXHomeViewDataSource : WXTableViewSectionedDataSource

- (void)reloadHomeTableViewData:(NSArray*)dataList;
@end
