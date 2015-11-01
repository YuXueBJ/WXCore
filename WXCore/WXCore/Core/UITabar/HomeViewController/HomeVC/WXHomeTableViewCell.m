//
//  WXHomeTableViewCell.m
//  WXCore
//
//  Created by 朱洪伟 on 15/10/24.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXHomeTableViewCell.h"
#import "WXTableViewItem.h"
#import "WXHomeTableViewItem.h"
#import "WXHomeTableViewObject.h"
#import "ViewCreatorHelper.h"

@interface WXHomeTableViewCell ()

@end

@implementation WXHomeTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    
    WXTableViewItem *item = (WXTableViewItem *)object;
    if (item.cellHeight) {
        return item.cellHeight;
    }
    //直播封面高度
//    CGFloat coverHeight = SCREEN_WIDTH/2;
    
    //主播信息区域高度
    CGFloat infoAreaHeight = 50;
    
//    item.cellHeight = coverHeight + infoAreaHeight + 10;
    
    return infoAreaHeight;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLable = [ViewCreatorHelper createLabelWithTitle:nil font:[UIFont systemFontOfSize:16.0f] frame:CGRectZero textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLable];
    }
    return self;
}
- (void)setObject:(id)object {
    [super setObject:object];
    if (!object) {
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    WXHomeTableViewItem * item = (WXHomeTableViewItem*)object;
    WXHomeTableViewObject * data = item.home_Object;
    self.titleLable.text = data.title;
    self.subTitleLable.text = data.subTitle;
}
- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews
{
    [super layoutSubviews];
   self.titleLable.frame = CGRectMake(30, 10, self.width-40, 20);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
