//
// SVPullToRefresh.m
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//

#import <QuartzCore/QuartzCore.h>
#import "SVPullToRefresh.h"
//#import "AudioManager.h"
#import "UIViewAdditions.h"

#define kFootViewHeight 40.0f
#define PAUSETIMES .5f
enum {
    SVPullToRefreshStateHidden = 1,
	SVPullToRefreshStateVisible,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading
};

typedef NSUInteger SVPullToRefreshState;

static CGFloat const SVPullToRefreshViewHeight = 60;

@interface SVPullToRefreshArrow : UIView
@property (nonatomic, strong) UIColor *arrowColor;
@end


@interface SVPullToRefresh ()

- (void)rotateArrow:(float)degrees hide:(BOOL)hide;
- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;

- (void)startObservingScrollView;
- (void)stopObservingScrollView;

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, copy) void (^infiniteScrollingActionHandler)(void);
@property (nonatomic, readwrite) SVPullToRefreshState state;

@property (nonatomic, unsafe_unretained) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *originalTableFooterView;

@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;
@property (nonatomic, assign) BOOL isObservingScrollView;

@end



@implementation SVPullToRefresh

// public properties
@synthesize pullToRefreshActionHandler, infiniteScrollingActionHandler, arrowColor, textColor, activityIndicatorViewStyle, lastUpdatedDate, dateFormatter;

@synthesize state;
@synthesize scrollView = _scrollView;
@synthesize arrow, activityIndicatorView, titleLabel, dateLabel, originalScrollViewContentInset, originalTableFooterView, showsPullToRefresh, showsInfiniteScrolling, isObservingScrollView;
@synthesize refreshView;

#pragma mark - RSLanguageManagerDelegate
- (void)ResourceForMutiLanguage:(id)sender
{
    if (self.dateLabel.text.length > 0)
    {
        NSArray *strArray = [self.dateLabel.text componentsSeparatedByString:@": "];
        //NSString *updateString = [strArray objectAtIndex:0];
        NSString *detailString = [strArray objectAtIndex:1];
        self.dateLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"最后更新: %@",RS_CURRENT_LANGUAGE_TABLE,nil), detailString];
    }
}

#pragma mark -
- (void)dealloc {
    [self stopObservingScrollView];
//    [RSAPPCONTEXT.languegeManager removeChangeLanguegeObject:self];

}

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectZero];
//    [RSAPPCONTEXT.languegeManager addChangeLanguegeObject:self];
    self.scrollView = scrollView;
    
    // default styling values
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.textColor = [UIColor darkGrayColor];
    self.arrowColor = [UIColor darkGrayColor];
    
    self.originalScrollViewContentInset = self.scrollView.contentInset;
    _pauseTimes = 0.0;
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(newSuperview == self.scrollView)
        [self startObservingScrollView];
    else if(newSuperview == nil)
        [self stopObservingScrollView];
}

- (void)layoutSubviews {
    if(infiniteScrollingActionHandler) {
        self.activityIndicatorView.center = CGPointMake(roundf(self.bounds.size.width/2.0f), roundf(self.bounds.size.height/2.0f));
    } else
        self.activityIndicatorView.center = self.arrow.center;
}

#pragma mark - Getters

- (UIImageView *)arrow {
    if(!arrow && pullToRefreshActionHandler) {
        arrow = [[UIImageView alloc] initWithImage:self.arrowImage];
        arrow.frame = CGRectMake(40, 6, 22, 48);
        arrow.backgroundColor = [UIColor clearColor];
    }
    return arrow;
}
-(XYPullToRefreshImageview*)refreshView{
    if (!refreshView && pullToRefreshActionHandler) {
        refreshView = [[XYPullToRefreshImageview alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 30)/2, 15, 30, 30)];
        refreshView.backgroundColor = [UIColor clearColor];
    }
    return refreshView;
}

- (UIImage *)arrowImage {
    CGRect rect = CGRectMake(0, 0, 22, 48);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, rect);
    
    [self.arrowColor set];
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, [[UIImage imageNamed:@"arrow.png"] CGImage]);
    CGContextFillRect(context, rect);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}


- (UIActivityIndicatorView *)activityIndicatorView {
    if(!activityIndicatorView) {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicatorView.hidesWhenStopped = YES;
// 去掉默认样式
//        [self addSubview:activityIndicatorView];
    }
    return activityIndicatorView;
}

- (UILabel *)dateLabel {
    if(!dateLabel && pullToRefreshActionHandler) {
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, self.superview.bounds.size.width, 20)];
        dateLabel.font = [UIFont systemFontOfSize:12];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment	= NSTextAlignmentCenter;
        dateLabel.textColor = textColor;
//        [self addSubview:dateLabel];
        
        CGRect titleFrame = titleLabel.frame;
        titleFrame.origin.y = 12;
        titleLabel.frame = titleFrame;
    }
    return dateLabel;
}

- (NSDateFormatter *)dateFormatter {
    if(!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		dateFormatter.locale = [NSLocale currentLocale];
    }
    return dateFormatter;
}

- (UIEdgeInsets)originalScrollViewContentInset {
    return UIEdgeInsetsMake(originalScrollViewContentInset.top, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
}

#pragma mark - Setters

- (void)setPullToRefreshActionHandler:(void (^)(void))actionHandler {
    pullToRefreshActionHandler = [actionHandler copy];
    [_scrollView addSubview:self];
    self.showsPullToRefresh = YES;
    
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.superview.bounds.size.width, 20)];
//    titleLabel.text = NSLocalizedStringFromTable(@"下拉可以刷新",RS_CURRENT_LANGUAGE_TABLE,nil);
//    titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.textColor = textColor;
//    titleLabel.textAlignment = UITextAlignmentCenter;
//    [self addSubview:titleLabel];
    
    //    [self addSubview:self.arrow];
    [self addSubview:self.refreshView];
    
    self.state = SVPullToRefreshStateHidden;
    self.frame = CGRectMake(0, -SVPullToRefreshViewHeight, self.scrollView.bounds.size.width, SVPullToRefreshViewHeight);
    
//    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, SVPullToRefreshViewHeight-3, self.scrollView.bounds.size.width, 3)];
//    [bottomLine setBackgroundColor:RGBCOLOR(76, 163, 251)];
//    [self addSubview:bottomLine];
}
- (void)setInfiniteScrollingActionHandler:(void (^)(void))actionHandler {
    infiniteScrollingActionHandler = [actionHandler copy];
    self.state = SVPullToRefreshStateHidden;
    
    self.showsInfiniteScrolling = YES;
    
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        self.originalTableFooterView = [(UITableView*)self.scrollView tableFooterView];
        self.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, SVPullToRefreshViewHeight);
        [(UITableView*)self.scrollView setTableFooterView:self];
    }
    else
    {
        [_scrollView addSubview:self];
    }
    
    [self setNeedsLayout];
}


//- (void)setInfiniteScrollingActionHandler:(void (^)(void))actionHandler {
//    self.originalTableFooterView = [(UITableView*)self.scrollView tableFooterView];
//    infiniteScrollingActionHandler = [actionHandler copy];
//    self.showsInfiniteScrolling = YES;
//    self.frame = CGRectMake(0, 0, self.scrollView.bounds.size.width, SVPullToRefreshViewHeight);
//    [(UITableView*)self.scrollView setTableFooterView:self];
//    self.state = SVPullToRefreshStateHidden;
//    [self layoutSubviews];
//}

- (void)setArrowColor:(UIColor *)newArrowColor {
    arrowColor = newArrowColor;
    self.arrow.image = self.arrowImage;
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    titleLabel.textColor = newTextColor;
	dateLabel.textColor = newTextColor;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)viewStyle {
    self.activityIndicatorView.activityIndicatorViewStyle = viewStyle;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {
//        if(self.state == SVPullToRefreshStateHidden && contentInset.top == self.originalScrollViewContentInset.top)
//            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//                arrow.alpha = 0;
//            } completion:NULL];
    }];
}

- (void)setLastUpdatedDate:(NSDate *)newLastUpdatedDate {
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"最后更新: %@",RS_CURRENT_LANGUAGE_TABLE,nil), newLastUpdatedDate?[self.dateFormatter stringFromDate:newLastUpdatedDate]:NSLocalizedString(@"Never",)];
}

- (void)setDateFormatter:(NSDateFormatter *)newDateFormatter {
	dateFormatter = newDateFormatter;
    self.dateLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"最后更新: %@",RS_CURRENT_LANGUAGE_TABLE,nil), self.lastUpdatedDate?[newDateFormatter stringFromDate:self.lastUpdatedDate]:NSLocalizedString(@"Never",)];
}

//- (void)setShowsInfiniteScrolling:(BOOL)show {
//    showsInfiniteScrolling = show;
//    if(!show)
//        [(UITableView*)self.scrollView setTableFooterView:self.originalTableFooterView];
//    else
//        [(UITableView*)self.scrollView setTableFooterView:self];
//}

- (void)setShowsInfiniteScrolling:(BOOL)show {
    showsInfiniteScrolling = show;
    if ([_scrollView isKindOfClass:[UITableView class]]) {
        if(!show)
            [(UITableView*)self.scrollView setTableFooterView:self.originalTableFooterView];
        else
            [(UITableView*)self.scrollView setTableFooterView:self];
        
    }else{
        self.hidden = !show;
    }
}

#pragma mark -

- (void)startObservingScrollView {
    if (self.isObservingScrollView)
        return;
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    self.isObservingScrollView = YES;
}

- (void)stopObservingScrollView {
    if(!self.isObservingScrollView)
        return;
    
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    self.isObservingScrollView = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(pullToRefreshActionHandler) {
        if (self.state == SVPullToRefreshStateLoading) {
            CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
            CGFloat bound = self.originalScrollViewContentInset.top + SVPullToRefreshViewHeight;
            offset = MIN(offset, bound);
//            offset = self.originalScrollViewContentInset.top;
            UIEdgeInsets in = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
            self.scrollView.contentInset = in;
        } else {
            CGFloat scrollOffsetThreshold = self.frame.origin.y-self.originalScrollViewContentInset.top - self.bottom;
            
            if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered)
                self.state = SVPullToRefreshStateLoading;
            else if(contentOffset.y > scrollOffsetThreshold && contentOffset.y < -self.originalScrollViewContentInset.top && self.scrollView.isDragging && self.state != SVPullToRefreshStateLoading)
                self.state = SVPullToRefreshStateVisible;
            else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateVisible)
                self.state = SVPullToRefreshStateTriggered;
            else if(contentOffset.y >= -self.originalScrollViewContentInset.top && self.state != SVPullToRefreshStateHidden)
                self.state = SVPullToRefreshStateHidden;
            
            [self.refreshView setPullProgress:contentOffset.y];
        }
    }
    else if(infiniteScrollingActionHandler) {
        CGFloat scrollOffsetThreshold = self.scrollView.contentSize.height-self.scrollView.bounds.size.height-self.originalScrollViewContentInset.top;
        
        if(contentOffset.y > MAX(scrollOffsetThreshold, self.scrollView.bounds.size.height-self.scrollView.contentSize.height) && self.state == SVPullToRefreshStateHidden)
            self.state = SVPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold)
            self.state = SVPullToRefreshStateHidden;
    }
}

- (void)triggerRefresh {
    [self.scrollView setContentOffset:CGPointMake(0, -SVPullToRefreshViewHeight) animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
        [NSThread sleepForTimeInterval:.35f];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.state = SVPullToRefreshStateLoading;
        });
    });
}

- (void)startAnimating{
    state = SVPullToRefreshStateLoading;
    _pauseTimes = PAUSETIMES;
    [self startTiming];
    titleLabel.text = NSLocalizedStringFromTable(@"  正在更新  ",RS_CURRENT_LANGUAGE_TABLE,nil);
    [self.activityIndicatorView startAnimating];
    [self.refreshView startloading];
    UIEdgeInsets newInsets = self.originalScrollViewContentInset;
    newInsets.top = self.frame.origin.y*-1+self.originalScrollViewContentInset.top;
    newInsets.bottom = self.scrollView.contentInset.bottom;
    [self setScrollViewContentInset:newInsets];
    [self.scrollView setContentOffset:CGPointMake(0, -self.frame.size.height-self.originalScrollViewContentInset.top) animated:NO];
//    [self rotateArrow:0 hide:YES];
}

- (void)stopAnimating {//在开始刷新过0.5秒后 再停止动画   ||可以会有在0.5还没有结束又下拉一次，有可能这原因会导致出来问题，但暂时没有发现，还需完善
    [self stopAnimatingDelayed:YES];
    
}

- (void)stopAnimatingDelayed:(BOOL)delayed {
    if (delayed) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_pauseTimes * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.state = SVPullToRefreshStateHidden;
        });
    }
    else {
        self.state = SVPullToRefreshStateHidden;
    }
    
}
- (void)startTiming //开始定时，在开始下拉时0.5秒后就可以直接sotp，如果没有过0.5秒就stop的话，就延迟0.5秒stop
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_pauseTimes * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _pauseTimes = 0.0;
    });
}
- (void)setState:(SVPullToRefreshState)newState {
    
    if(pullToRefreshActionHandler && !self.showsPullToRefresh && !self.activityIndicatorView.isAnimating) {
//        titleLabel.text = NSLocalizedStringFromTable(@"",RS_CURRENT_LANGUAGE_TABLE,nil);
//        [self.activityIndicatorView stopAnimating];
        [self setScrollViewContentInset:self.originalScrollViewContentInset];
//        [self rotateArrow:0 hide:YES];
        return;
    }
    
    if(infiniteScrollingActionHandler && !self.showsInfiniteScrolling)
        return;
    
    if(state == newState)
        return;
    
    SVPullToRefreshState oldState = state;
    state = newState;
    
    if(pullToRefreshActionHandler) {
        switch (newState) {
            case SVPullToRefreshStateHidden:
//                titleLabel.text = NSLocalizedStringFromTable(@"下拉可以刷新",RS_CURRENT_LANGUAGE_TABLE,nil);
//                [self.activityIndicatorView stopAnimating];
                [self setScrollViewContentInset:self.originalScrollViewContentInset];
//                [self rotateArrow:0 hide:NO];
                [self.refreshView renewState];
                
                if (oldState == SVPullToRefreshStateLoading) {
//                    [[AudioManager sharedInstance] playSystemSoundWithTag:SoundEffectType_RefreshFinish];
                }
                break;
                
            case SVPullToRefreshStateVisible:
//                titleLabel.text = NSLocalizedStringFromTable(@"下拉可以刷新",RS_CURRENT_LANGUAGE_TABLE,nil);
//                arrow.alpha = 1;
//                [self.activityIndicatorView stopAnimating];
                [self setScrollViewContentInset:self.originalScrollViewContentInset];
//                [self rotateArrow:0 hide:NO];
                [self.refreshView setArrowTransform:NO];
                if(oldState == SVPullToRefreshStateTriggered){
//                    [[AudioManager sharedInstance] playSystemSoundWithTag:SoundEffectType_RefreshRelease];
                }
                break;
                
            case SVPullToRefreshStateTriggered:
//                titleLabel.text = NSLocalizedStringFromTable(@"松开即可刷新",RS_CURRENT_LANGUAGE_TABLE,nil);
//                [self rotateArrow:M_PI hide:NO];
//                [self.refreshView setArrowTransform:YES];
                if(oldState == SVPullToRefreshStateVisible){
//                    [[AudioManager sharedInstance] playSystemSoundWithTag:SoundEffectType_RefreshRelease];
                }
                break;
                
            case SVPullToRefreshStateLoading:
                _pauseTimes = PAUSETIMES;
                [self startTiming];
                
                [self startAnimating];
//                [self.refreshView startloading];
                pullToRefreshActionHandler();
                break;
        }
    }
    else if(infiniteScrollingActionHandler) {
        switch (newState) {
            case SVPullToRefreshStateHidden:
            {
                self.hidden = YES;
//                [self.activityIndicatorView stopAnimating];
            }
                break;
                
            case SVPullToRefreshStateLoading:
            {
                self.hidden = NO;
//                [self.activityIndicatorView startAnimating];
                
                infiniteScrollingActionHandler();
            }
                break;
        }
    }
}

- (void)rotateArrow:(float)degrees hide:(BOOL)hide {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
        self.arrow.layer.opacity = !hide;
        [self.arrow setNeedsDisplay];//ios 4
    } completion:NULL];
}

@end


#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;
static char UIScrollViewInfiniteScrollingView;

@implementation UIScrollView (SVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh, infiniteScrollingView, showsInfiniteScrolling;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    self.pullToRefreshView.pullToRefreshActionHandler = actionHandler;
    // 统一添加时间 设置
    // you can configure how that date is displayed
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
//    [self.pullToRefreshView setDateFormatter:formatter];
//    
//    // you can also display the "last updated" date
//    self.pullToRefreshView.lastUpdatedDate = [NSDate date];
//    
//    self.pullToRefreshView.dateLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
//    self.pullToRefreshView.dateLabel.font				= [UIFont systemFontOfSize:12.0f];
//    //self.tableView.pullToRefreshView.dateLabel.textColor		= [UIColor colorForKey:@"colorOfRefreshHeaderLabel"];
//    //self.tableView.pullToRefreshView.dateLabel.shadowColor		= [UIColor colorForKey:@"colorOfRefreshHeaderLabelShadow"];
//    self.pullToRefreshView.dateLabel.shadowOffset		= CGSizeMake(0.0f, 1.0f);
//    self.pullToRefreshView.dateLabel.textAlignment	= UITextAlignmentCenter;
//    
//    self.pullToRefreshView.titleLabel.autoresizingMask	= UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
//    self.pullToRefreshView.titleLabel.font				= [UIFont boldSystemFontOfSize:14.0f];
//    //self.tableView.pullToRefreshView.titleLabel.textColor			= [UIColor colorForKey:@"colorOfRefreshHeaderLabel"];
//    //self.tableView.pullToRefreshView.titleLabel.shadowColor			= [UIColor colorForKey:@"colorOfRefreshHeaderLabelShadow"];
//    self.pullToRefreshView.titleLabel.shadowOffset		= CGSizeMake(0.0f, 1.0f);
//    self.pullToRefreshView.titleLabel.textAlignment		= UITextAlignmentCenter;
//    
//    UIImage *arrowImage = [UIImage imageForKey:@"refresh_header_arrow"];
//    self.pullToRefreshView.arrow.image = arrowImage;
//    
//    CGRect pullViewFrame = self.pullToRefreshView.frame;
//    UIImage		*refreshImage	= [UIImage imageForKey:@"refresh_watermark"];
//    UIImageView *refreshBGView	= [[UIImageView alloc] initWithImage:refreshImage];
//    refreshBGView.tag = 102030;//为了以后可以找到这个view更换图片
//    refreshBGView.frame = CGRectMake((pullViewFrame.size.width - refreshBGView.image.size.width) / 2,
//                                     pullViewFrame.size.height - 67.0f - refreshBGView.image.size.height,
//                                     refreshImage.size.width,
//                                     refreshImage.size.height);
//    [self.pullToRefreshView addSubview:refreshBGView];

}

- (void)addInfiniteScrollingWithActionHandler:(void (^)(void))actionHandler {
    self.infiniteScrollingView.infiniteScrollingActionHandler = actionHandler;
}

- (void)setPullToRefreshView:(SVPullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"pullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"pullToRefreshView"];
}

- (void)setInfiniteScrollingView:(SVPullToRefresh *)pullToRefreshView {
    [self willChangeValueForKey:@"infiniteScrollingView"];
    objc_setAssociatedObject(self, &UIScrollViewInfiniteScrollingView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"infiniteScrollingView"];
}

- (SVPullToRefresh *)pullToRefreshView {
    SVPullToRefresh *pullToRefreshView = objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
    if(!pullToRefreshView) {
        pullToRefreshView = [[SVPullToRefresh alloc] initWithScrollView:self];
        self.pullToRefreshView = pullToRefreshView;        
    }
    return pullToRefreshView;
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.showsPullToRefresh = showsPullToRefresh;
}

- (BOOL)showsPullToRefresh {
    return self.pullToRefreshView.showsPullToRefresh;
}

- (SVPullToRefresh *)infiniteScrollingView {
    SVPullToRefresh *infiniteScrollingView = objc_getAssociatedObject(self, &UIScrollViewInfiniteScrollingView);
    if(!infiniteScrollingView) {
        infiniteScrollingView = [[SVPullToRefresh alloc] initWithScrollView:self];
        self.infiniteScrollingView = infiniteScrollingView;
    }
    return infiniteScrollingView;
}

- (void)setShowsInfiniteScrolling:(BOOL)showsInfiniteScrolling
{
    ////////////////////////////////////////////////////////////////////////////////////////////////    
    // modified by zhongsheng
    // 支持非tableView的下拉刷新
    if (showsInfiniteScrolling && ![self isKindOfClass:[UITableView class]]) {
        CGSize contentSize = self.contentSize;
        if (!self.infiniteScrollingView) {
            self.infiniteScrollingView = [[SVPullToRefresh alloc] initWithScrollView:self];
        }
        self.infiniteScrollingView.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, kFootViewHeight);
        self.infiniteScrollingView.top = contentSize.height;
        self.infiniteScrollingView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.infiniteScrollingView];
        contentSize.height += (kFootViewHeight-5.0f);
        self.contentSize = contentSize;
    }else if(![self isKindOfClass:[UITableView class]]){        
        [self.infiniteScrollingView removeFromSuperview];
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////
    
    self.infiniteScrollingView.showsInfiniteScrolling = showsInfiniteScrolling;
}

- (BOOL)showsInfiniteScrolling {
    return self.infiniteScrollingView.showsInfiniteScrolling;
}
@end

