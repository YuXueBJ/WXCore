//
//  HomeDataSave.m
//  TestPersistence
//
//  Created by 朱洪伟 on 15/12/12.
//  Copyright © 2015年 个人博客：www.zhwios.com. All rights reserved.
//

#import "HomeDataSave.h"
#import "WSPersistenceContext.h"

@implementation HomeDataSave

- (id)initWithContext:(WSPersistenceContext *)context {
    self = [super initWithContext:context];
    if (self) {
        //库中对应的表，一类一表
         [context registerClass:[HomeDataObject class]];
        
//        [context registerClass:[AAAA class]];
//        [context registerClass:[BBBB class]];

    }
    return self;
}

-(void)saveHomeDataList:(HomeDataObject*)lisetObject
{
    [_context executeInTransaction:^(FMDatabase *db) {
        [self saveOrUpdateObject:lisetObject];        
    }];
}
- (void)updatebHomeData:(NSNumber*)homeId
{
//    NSString *sql = [NSString stringWithFormat:@"update Home_data_object set walet_is_rob  = '%@' where data_id = '%@'",waletIsRob,workID];
    NSString *sql = [NSString stringWithFormat:@"update Home_data_object set home_id  = '%@'",homeId];
    [self.context executeUpdateSql:sql];
}

- (void)deleteHomeListDataID:(NSNumber*)homeId
{
    NSString *criteriaStr =[NSString stringWithFormat:@"where home_id ='%@'",homeId];
    [self deleteObjectsByClass:[HomeDataObject class] criteria:criteriaStr];
}
- (void)deleteAllHomeList
{
    [self deleteObjectsByClass:[HomeDataObject class] criteria:@""];
}
- (NSArray *)getAllHomeDataID:(NSNumber*)homeId;
{
    NSString *criteriaStr =[NSString stringWithFormat:@"where home_id ='%@'",homeId];
    NSArray *resultList = (NSArray *)[self findObjectsByClass:[HomeDataObject class] criteria:criteriaStr];
    return resultList;
}
- (NSArray *)getAllHomeListData
{
    NSArray *resultList = (NSArray *)[self findObjectsByClass:[HomeDataObject class] criteria:@""];
    return resultList;
}
@end
