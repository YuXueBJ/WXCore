//
//  WXTableViewCell.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XYT_CELL_INTERACTION_BLOCK_DURATION 1.2f


@interface WXTableViewCell : UITableViewCell
{
    id _object;

}
@property (nonatomic, strong) id            object;
@property (nonatomic, copy)   NSIndexPath * indexPath;
@property (nonatomic, assign) BOOL          userInteractionBlockSafe;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object;


//object属性observer相关
/**开始监听object属性,在subclass中通过该方法可自定义添加监听的属性*/
- (void)startObserveObjectProperty;
/**清除监听,在subclass中应该清除已添加的属性*/
- (void)finishObserveObjectProperty;

/**监听一个属性*/
- (void)addObservedProperty:(NSString *)property;
/**移出监听*/
- (void)removeObservedProperty:(NSString *)property;
/**属性发生变动的回调*/
- (void)objectPropertyChanged:(NSString *)property;
/**阻塞自身*/
- (void)detachInteractionBlock;
/**解除阻塞*/
- (void)cancelInteractionBlock;


@end
