//
//  WXHomeViewDataSource.m
//  WXCore
//
//  Created by 朱洪伟 on 15/10/21.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXHomeViewDataSource.h"
#import "WXHomeTableViewCell.h"
#import "WXHomeTableViewItem.h"

#define kCountPerPage 10

@implementation WXHomeViewDataSource

-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[WXHomeTableViewItem class]]) {
        return [WXHomeTableViewCell class];
    }
    return [super tableView:tableView cellClassForObject:object];
}

- (void)reloadHomeTableViewData:(NSArray*)dataList
{
    WXTableViewSectionObject *firstSectionObj = [[WXTableViewSectionObject alloc] init];
    for (NSDictionary *dic  in dataList) {
        WXHomeTableViewItem * item=[[WXHomeTableViewItem alloc] initWithObject:dic];
        [firstSectionObj.items addObject:item];
    }
    self.sections = [NSMutableArray arrayWithObjects:firstSectionObj, nil];
    if ([dataList count]>=kCountPerPage) {
        WXTableViewSectionObject * loadmore=[[WXTableViewSectionObject alloc] init];
        WXTableViewLoadMoreItem *moreItem = [[WXTableViewLoadMoreItem alloc] init];
        [loadmore.items addObject:moreItem];
        [self.sections addObject:loadmore];
    }
}
- (void)reloadMoreTableViewData:(NSArray*)dataList
{
    WXTableViewSectionObject * firstSectionObj=[self.sections objectAtIndex:0];
    for (NSDictionary *dic  in dataList) {
        WXHomeTableViewItem * item=[[WXHomeTableViewItem alloc] initWithObject:dic];
        [firstSectionObj.items addObject:item];
    }
    if ([dataList count]<kCountPerPage) {
        [self.sections removeObjectAtIndex:1];
    }
}
- (NSString*)titleForEmpty {
    return @"点击重新刷新...";
}
- (BOOL)buttonExecutable{
    return YES;
}
- (BOOL)buttonErrorExecutable{
    return YES;
}
- (NSString*)subtitleForEmpty {
    return @"没有数据...";
}
- (UIImage*)imageForEmpty {
    return [UIImage imageNamed:@"coffee_cup_empty"];
}
- (NSString*)titleForError:(NSError*)error {
    return @"加载出错";
}
- (UIImage*)imageForError:(NSError*)error {
    return [UIImage imageNamed:@"404Error"];
}

@end
