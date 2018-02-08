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

static const CGFloat kMoreButtonMargin = 130;

@interface WXTableViewLoadMoreCell()

- (void)buildLoadingAnimationView;
- (void)buildTitleLabel;

@end
@implementation WXTableViewLoadMoreCell

@synthesize animating = _animating;
//@synthesize refreshView = _refreshView;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return  Load_More_Cell_ROW_HEIGHT * 1;
}
+ (BOOL)isNibOrCored
{
    return YES;
}
+ (BOOL)isCacheCell{
    return YES;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _animating = NO;
        
//        [self buildTitleLabel];
        [self buildLoadingAnimationView];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    _animating = NO;
    
//    [self buildTitleLabel];
    [self buildLoadingAnimationView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
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
    
    _loadingAnimationView.left	= self.contentView.width - (_loadingAnimationView.width + 6);
    _loadingAnimationView.top	= floor(self.contentView.height / 2 - _loadingAnimationView.height / 2);
    
    _titleLabel.frame = CGRectMake(0,
                                   _titleLabel.top,
                                   self.contentView.width,
                                   _titleLabel.height);
    
}

- (void)setObject:(id)object
{
    if (_object != object) {
        [super setObject:object];
        
        if (_object) {
            WXTableViewLoadMoreItem *item = _object;
            _titleLabel.text	= @"加载更多...";
            self.animating		= item.isLoading;
            [self.contentView setBackgroundColor:[UIColor clearColor]];
            
        }
    }
}

#pragma mark- UI
- (void)buildLoadingAnimationView
{
//    _loadingAnimationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.contentView addSubview:_loadingAnimationView];
}

- (void)resetLoadingAnimationView:(UIActivityIndicatorView*)loadingView
{
    if (_loadingAnimationView != nil) {
        [_loadingAnimationView removeFromSuperview];
        _loadingAnimationView = nil;
    }
    _loadingAnimationView = loadingView;
    [self.contentView addSubview:_loadingAnimationView];
}

- (void)buildTitleLabel
{
//    _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
//    _titleLabel.backgroundColor = [UIColor clearColor];
//    _titleLabel.autoresizingMask			= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _titleLabel.font						= [UIFont boldSystemFontOfSize:15];
//    _titleLabel.textColor					= kDefaultHomeTextColor;
//    _titleLabel.highlightedTextColor		= [UIColor clearColor];
//    _titleLabel.textAlignment				= NSTextAlignmentCenter;
//    _titleLabel.lineBreakMode				= NSLineBreakByTruncatingTail;
//    _titleLabel.adjustsFontSizeToFitWidth	= YES;
//    _titleLabel.text = @"加载更多...";
//    [self.contentView addSubview:_titleLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
}
- (void)drawRect:(CGRect)rect {
    
    //    //分割线
        UIColor *lineColor = [RGBCOLOR(207, 207,207) colorWithAlphaComponent:0.3];
        [lineColor setFill];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context, CGRectMake(10, self.height - 1, self.width-20, 1));
}

@end
