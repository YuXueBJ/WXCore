//
//  WXTableViewLoadMoreCell.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//
#define Load_More_Cell_ROW_HEIGHT                 44.0f

#import "WXCode.h"
#import "WXTableViewLoadMoreCell.h"
#import "Masonry.h"

@interface WXTableViewLoadMoreCell()

@end
@implementation WXTableViewLoadMoreCell

@synthesize animating = _animating;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return  Load_More_Cell_ROW_HEIGHT * 1;
}
+ (BOOL)isNibOrCored
{
    return NO;
}
+ (BOOL)isCacheCell{
    return YES;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _animating = NO;
//        [self buildLoadingAnimationView];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self.contentView addSubview:self.loadingAnimationView];
        [self.contentView addSubview:self.moreTextLabel];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _animating = NO;
}
- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    if (!self) {
        return;
    }
    if (animating) {
        [self.loadingAnimationView startAnimating];
    } else {
        [self.loadingAnimationView stopAnimating];
    }
}
- (void)dealloc{
    [self finishObserveObjectProperty];
}
- (void)objectPropertyChanged:(NSString *)property {
    if([property isEqualToString:@"isLoading"]){
        WXTableViewLoadMoreItem *item = self.object;
        self.animating		= item.isLoading;
    }
}

- (void)startObserveObjectProperty {
    [self addObservedProperty:@"isLoading"];
}

- (void)finishObserveObjectProperty {
    [self removeObservedProperty:@"isLoading"];
}


#pragma mark- Override
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setObject:(id)object{
    
    if (_object != object) {
        [super setObject:object];
        if (_object) {
            WXTableViewLoadMoreItem *item = _object;
            self.moreTextLabel.text	= @"加载更多...";
            self.animating		= item.isLoading;
            [self.contentView setBackgroundColor:[UIColor clearColor]];
        }
        [self.moreTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.width.equalTo(@100);
            make.height.equalTo(self.mas_height);
        }];
        [self.loadingAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.right.equalTo(self.moreTextLabel.mas_left).offset(-10);
             make.width.equalTo(@20);
             make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
}

#pragma mark- UI
- (void)resetLoadingAnimationView:(UIActivityIndicatorView*)loadingView
{
    if (_loadingAnimationView != nil) {
        [_loadingAnimationView removeFromSuperview];
        _loadingAnimationView = nil;
    }
    _loadingAnimationView = loadingView;
    [self.contentView addSubview:_loadingAnimationView];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
}
- (void)drawRect:(CGRect)rect {
        //分割线
        UIColor *lineColor = [RGBCOLOR(207, 207,207) colorWithAlphaComponent:0.3];
        [lineColor setFill];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context, CGRectMake(10, self.height - 1, self.width-20, 1));
}
- (UIActivityIndicatorView*)loadingAnimationView{
    if (!_loadingAnimationView) {
        _loadingAnimationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _loadingAnimationView;
}
- (UILabel*)moreTextLabel{
    if (!_moreTextLabel) {
        _moreTextLabel = [ViewCreatorHelper createLabelWithTitle:nil font:[UIFont systemFontOfSize:15.0f] frame:CGRectZero textColor:RGBCOLOR(51, 51, 51) textAlignment:NSTextAlignmentLeft];
    }
    return _moreTextLabel;
}
@end
