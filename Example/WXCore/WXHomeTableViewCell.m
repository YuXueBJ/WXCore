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

#define kLineBackColor                  RGBCOLOR(207, 207,207);    

@interface WXHomeTableViewCell ()
@property (nonatomic,strong)UILabel * lineLable;

@end

@implementation WXHomeTableViewCell

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
    
    WXTableViewItem *item = (WXTableViewItem *)object;
    if (item.cellHeight) {
        return item.cellHeight;
    }
    //Cell区域高度
    CGFloat infoAreaHeight = 50;
    
    return infoAreaHeight;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLable = [ViewCreatorHelper createLabelWithTitle:nil font:[UIFont systemFontOfSize:16.0f] frame:CGRectZero textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
        [self.contentView addSubview:self.titleLable];
        
        self.lineLable = [ViewCreatorHelper createLabelWithTitle:nil font:[UIFont systemFontOfSize:12] frame:CGRectZero textColor:[UIColor grayColor] textAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.lineLable];
        self.lineLable.backgroundColor=kLineBackColor;
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
    [super awakeFromNib];
}
+ (BOOL)isNibOrCored{
    return NO;
}
+ (BOOL)isCacheCell{
    return NO;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
   self.titleLable.frame = CGRectMake(30, 10, self.width-40, 20);
    self.lineLable.frame = CGRectMake(0, self.height - 1, self.width, 0.5);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
