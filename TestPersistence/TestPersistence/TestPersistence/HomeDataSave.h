//
//  HomeDataSave.h
//  TestPersistence
//
//  Created by 朱洪伟 on 15/12/12.
//  Copyright © 2015年 个人博客：www.zhwios.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSPersistenceService.h"
#import "HomeDataObject.h"

@interface HomeDataSave : WSPersistenceService

- (void)saveHomeDataList:(HomeDataObject*)lisetObject;
- (void)updatebHomeData:(NSNumber*)homeId;

- (void)deleteHomeListDataID:(NSNumber*)homeId;
- (void)deleteAllHomeList ;

- (NSArray *)getAllHomeDataID:(NSNumber*)homeId;
- (NSArray *)getAllHomeListData;

@end
