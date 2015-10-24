//
//  WXTableViewLoadMoreCell.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//
#define Load_More_Cell_ROW_HEIGHT                 44.0f


#import "WXTableViewLoadMoreCell.h"
static const CGFloat kMoreButtonMargin = 130;

@interface WXTableViewLoadMoreCell()

- (void)buildLoadingAnimationView;
- (void)buildTitleLabel;

@end
@implementation WXTableViewLoadMoreCell

@synthesize animating = _animating;
@synthesize refreshView = _refreshView;

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return  Load_More_Cell_ROW_HEIGHT * 1;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _animating = NO;
        
        [self buildTitleLabel];
        [self buildLoadingAnimationView];
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.contentView addSubview:self.refreshView];
    }
    return self;
}

-(XYPullToRefreshImageview*)refreshView{
    if (_refreshView == nil) {
        _refreshView = [[XYPullToRefreshImageview alloc] initWithFrame:CGRectMake((PHONE_SCREEN_SIZE.width-30)/2, 10, 30, 30)];
        _refreshView.backgroundColor = [UIColor clearColor];
        UIImage *pullImage = [UIImage imageNamed:@"pull_refresh"];
        _refreshView.arrowImageView.image = pullImage;
    }
    return _refreshView;
}
- (void)setAnimating:(BOOL)animating {
    _animating = animating;
    if (animating) {
        [_refreshView startloading];
    } else {
        [_refreshView renewState];
    }
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
    
    _loadingAnimationView.left	= kMoreButtonMargin - (_loadingAnimationView.width + 6);
    _loadingAnimationView.top	= floor(self.contentView.height / 2 - _loadingAnimationView.height / 2);
    
    _titleLabel.frame = CGRectMake(kMoreButtonMargin,
                                   _titleLabel.top,
                                   self.contentView.width - (kMoreButtonMargin + 6),
                                   _titleLabel.height);
    
}

- (void)setObject:(id)object
{
    if (_object != object) {
        [super setObject:object];
        
        if (_object) {
            WXTableViewLoadMoreItem *item = _object;
            _titleLabel.text	= item.title;
            self.animating		= item.isLoading;
            [self.contentView setBackgroundColor:[UIColor clearColor]];
            
        }
    }
}

#pragma mark- UI
- (void)buildLoadingAnimationView
{
    _loadingAnimationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.contentView addSubview:_loadingAnimationView];
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
    _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.autoresizingMask			= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _titleLabel.font						= [UIFont boldSystemFontOfSize:15];
    //	_titleLabel.textColor					= [UIColor colorForKey:@"CommonModule-colorTypeC"];
    //	_titleLabel.highlightedTextColor		= [UIColor whiteColor];
    _titleLabel.textAlignment				= NSTextAlignmentLeft;
    _titleLabel.lineBreakMode				= NSLineBreakByTruncatingTail;
    _titleLabel.adjustsFontSizeToFitWidth	= YES;
    //    [_titleLabel setTextColor:[UIColor colorForKey:@"colorOfRefreshHeaderLabel"]];
    //    [_titleLabel setShadowColor:[UIColor colorForKey:@"colorOfRefreshHeaderLabelShadow"]];
    
    [self.contentView addSubview:_titleLabel];
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
    //    UIColor *lineColor = [[UIColor colorForKey:@"CommonModule-colorTypeC"] colorWithAlphaComponent:0.3];
    //    [lineColor setFill];
    //    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextFillRect(context, CGRectMake(10, self.height - 1, self.width-20, 1));
}

@end
