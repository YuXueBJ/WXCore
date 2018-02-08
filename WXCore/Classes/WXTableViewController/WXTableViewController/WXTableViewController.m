//
//  WXTableViewController.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewController.h"
#import "WXSearchDisplayController.h"


@interface WXTableViewController (delegate);

@end

@interface WXTableViewController (Private);

- (void)loadMoreAction;
@end
@interface WXTableViewController ()<UITableViewDelegate>
{
        UIView *_tableviewBackview;
}
@property (nonatomic,strong)UIRefreshControl * refreshControl;
- (MJRefreshNormalHeader*)installHeader;
- (MJRefreshAutoNormalFooter*)installFooter;
@end

@implementation WXTableViewController
@synthesize error = _error;
@synthesize tableView           = _tableView;
@synthesize tableWatermarkView  = _tableWatermarkView;
@synthesize tableOverlayView    = _tableOverlayView;
@synthesize loadingView         = _loadingView;
@synthesize errorView           = _errorView;
@synthesize emptyView           = _emptyView;
@synthesize tableViewStyle      = _tableViewStyle;
@synthesize showTableShadows    = _showTableShadows;
@synthesize dataSource          = _dataSource;
@synthesize loadingData         = _loadingData;
@synthesize searchViewController   = _searchViewController;
@synthesize isShowXingYunBackView;
@synthesize removeSearchBarBackgroundColor;


- (id)initWithStyle:(UITableViewStyle)style
{
    if (self = [super init]) {
        _tableViewStyle = style;
        _loadingData	= NO;
    }
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.isShowXingYunBackView = YES;
    }
    return self;
}


- (NSString *)defaultTitleForLoading
{
    return NSLocalizedString(@"Loading...", @"");
}

- (void)addToOverlayView:(UIView *)view
{
    if (!_tableOverlayView) {
        CGRect frame = self.view.bounds;
        _tableOverlayView = [[UIView alloc] initWithFrame:frame];
        _tableOverlayView.autoresizesSubviews	= YES;
        _tableOverlayView.autoresizingMask		= UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        NSInteger tableIndex = [_tableView.superview.subviews indexOfObject:_tableView];
        
        if (tableIndex != NSNotFound) {
            [_tableView.superview addSubview:_tableOverlayView];
        }
    }
    
    view.frame				= _tableOverlayView.bounds;
    view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableOverlayView addSubview:view];
}
- (void)addToWatermarkView:(UIView *)view
{
    if (!_tableWatermarkView) {
        CGRect frame = self.view.bounds;
        _tableWatermarkView = [[UIView alloc] initWithFrame:frame];
        _tableWatermarkView.autoresizesSubviews	= YES;
        _tableWatermarkView.autoresizingMask		= UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        //        [_tableWatermarkView setBackgroundColor:RGBCOLOR(255, 0, 0)];
        _tableOverlayView.userInteractionEnabled = YES;
        // 水印
        /*
         NSInteger tableIndex = [_tableView.superview.subviews indexOfObject:_tableView];
         
         if (tableIndex != NSNotFound) {
         [_tableView.superview insertSubview:_tableWatermarkView belowSubview:_tableView];
         }
         //*/
        // tableview之上
        [_tableView addSubview:_tableWatermarkView];
    }
    UIEdgeInsets edgeInsets = [_dataSource emptyViewEdgeInsets];
    CGRect viewFrame = _tableWatermarkView.bounds;
    viewFrame.origin.x += (edgeInsets.right - edgeInsets.left);
    viewFrame.origin.y += (edgeInsets.top - edgeInsets.bottom);
    view.frame				= viewFrame;
    view.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableWatermarkView addSubview:view];
}
- (void)resetOverlayView
{
    if (_tableOverlayView && !_tableOverlayView.subviews.count) {
        [_tableOverlayView removeFromSuperview];
        _tableOverlayView = nil;
    }
}

- (void)resetWatermarkView
{
    if (_tableWatermarkView && !_tableWatermarkView.subviews.count) {
        [_tableWatermarkView removeFromSuperview];
        _tableWatermarkView = nil;
    }
}

- (void)addSubviewOverTableView:(UIView *)view
{
    NSInteger tableIndex = [_tableView.superview.subviews
                            indexOfObject:_tableView];
    
    if (NSNotFound != tableIndex) {
        [_tableView.superview addSubview:view];
    }
}

- (void)layoutOverlayView
{
    if (_tableOverlayView) {
        _tableOverlayView.frame = [self rectForOverlayView];
    }
}

- (void)layoutWatermarkView
{
    if (_tableWatermarkView) {
        _tableWatermarkView.frame = [self rectForWatermarkView];
    }
}
- (void)fadeOutView:(UIView *)view
{
    [UIView beginAnimations:nil context:(__bridge void * _Nullable)(view)];
    [UIView setAnimationDuration:.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fadingOutViewDidStop:finished:context:)];
    view.alpha = 0;
    [UIView commitAnimations];
}

- (void)fadingOutViewDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIView *view = (__bridge UIView *)context;
    
    [view removeFromSuperview];
    view = nil;
}

- (void)setSearchViewController:(WXTableViewController *)searchViewController
{
    if (_searchViewController == searchViewController) {
        return;
    }
    _searchViewController = nil;
    _searchViewController = searchViewController;
    
    if (searchViewController) {
        if (nil == _searchController) {
            UISearchBar *searchBar = [[UISearchBar alloc] init];
            [searchBar sizeToFit];
            _searchController = [[WXSearchDisplayController alloc]
                                 initWithSearchBar:searchBar
                                 contentsController:self];
            
            if(searchViewController.removeSearchBarBackgroundColor || self.removeSearchBarBackgroundColor)
            {
                if([[UIDevice currentDevice] systemVersionByFloat]<7.0 || _searchController.searchBar.subviews.count >1)
                {
                    [[_searchController.searchBar.subviews objectAtIndex:0]removeFromSuperview];
                }
            }
            
        }

        _searchController.searchResultsViewController = searchViewController;
    } else {
        _searchController.searchResultsViewController = nil;
    }
}

#pragma mark -
#pragma mark UIViewController


- (void)loadView {
    [super loadView];
    
    WXBaseTableView *tab = [[WXBaseTableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
    self.tableView = tab;
    _tableView.frame = self.view.bounds;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    _shouldLoadTableView = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self.dataSource;
    self.showsPullToRefresh = NO;     // default is NO
    self.showsInfiniteScrolling = NO; // default is NO
}

-(void)doFitTableViewNoRefresh:(UIScrollView*)tab
{
    UIImage * image = [UIImage imageNamed:@"blueCircle"];
    UIImageView * bkTableView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:5]];
    bkTableView.frame = CGRectMake(0, 0, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
    [bkTableView setCenter:CGPointMake(160, -PHONE_SCREEN_SIZE.height/2)];
//    [tab addSubview:bkTableView];
}

-(void)doFitTableViewNoMore:(UIScrollView*)tab{
    
    UIImage * image = [UIImage imageNamed:@"blueCircle"];
    UIImageView * bkTableView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:5]];
    bkTableView.frame = CGRectMake(0, PHONE_SCREEN_SIZE.height, PHONE_SCREEN_SIZE.width, PHONE_SCREEN_SIZE.height);
    [bkTableView setCenter:CGPointMake(160, PHONE_SCREEN_SIZE.height +PHONE_SCREEN_SIZE.height/2)];
    [tab addSubview:bkTableView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = nil;
    //    self.tableView.backgroundColor = COMMEN_VIEW_BGCOLOR;
    
//    CGSize size = CGSizeMake(200,CGFLOAT_MAX);
//    CGSize labelsize = [self.title sizeWithFont:self.titleLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
//    CGSize labelsize = [self.title measureTextSize:self.titleLabel.font  desWidth:CGFLOAT_MAX];
    
//    self.titleLabel.width = labelsize.width;
    //    [self doFitTableViewNoMore:self.tableView];
    
    if (self.isShowXingYunBackView) {
        
      //  [self doFitTableViewNoRefresh:self.tableView];
        
        //        self.tableView.backgroundColor = [UIColor clearColor];
        //        _tableviewBackview =  [[UIView alloc] initWithFrame:self.tableView.bounds];
        //        [_tableviewBackview setBackgroundColor:COMMEN_VIEW_BGCOLOR];
        //        [self.view insertSubview:_tableviewBackview atIndex:0];
        //
        //
        //        UIImage *backImage = [UIImage imageForKey:@"refresh_bg"];
        //        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        //        backgroundView.image = [backImage stretchableImageWithLeftCapWidth:10 topCapHeight:backImage.size.height-10];
        //        [self.view insertSubview:backgroundView atIndex:0];
        //        [backgroundView release];
    }else{
        
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_lastInterfaceOrientation != self.interfaceOrientation) {
        _lastInterfaceOrientation = self.interfaceOrientation;
        [_tableView reloadData];
        
    } else if ([_tableView isKindOfClass:[WXBaseTableView class]]) {
        WXBaseTableView* tableView = (WXBaseTableView*)_tableView;
        tableView.showShadows = _showTableShadows;
    }

    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
    
    if (self.showsPullToRefresh) {
        MJRefreshNormalHeader * header = [self installHeader];
        self.tableView.mj_header = header;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        self.tableView.scrollsToTop = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
        self.tableView.scrollsToTop = NO;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}
- (void)showLoading:(BOOL)show {
    if (show) {
        
        [self showEmpty:NO];
        [self showError:NO];
        
        UIView *loadingTextView = [[UIView alloc] initWithFrame:self.view.bounds];
        loadingTextView.backgroundColor = [UIColor clearColor];
        
        UIImage *loadImage = [UIImage imageNamed:@"blueCircle"];
        UIImageView *loadImageView = [[UIImageView alloc] initWithImage:loadImage];
        
        UIEdgeInsets currentEdge =   [_dataSource emptyViewEdgeInsets];
        
        
        [loadImageView setFrame:CGRectMake(
                                           loadingTextView.centerX-loadImage.size.width/2,
                                           loadingTextView.centerY-loadImage.size.height/2-48+currentEdge.top,
                                           loadImage.size.width,
                                           loadImage.size.height)];
        
        [loadingTextView addSubview:loadImageView];
//        
//        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
////        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//        rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//        rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
//        rotationAnimation.duration = 1.0f;
//        rotationAnimation.repeatCount = CGFLOAT_MAX;
//        rotationAnimation.autoreverses = YES;
////        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        [loadImageView.layer addAnimation:rotationAnimation forKey:nil];
        
        self.loadingView = loadingTextView;
    } else {
        self.loadingView = nil;
    }
    
}

- (void)showError:(BOOL)show
{
    if (show) {
        NSString	*title		= [_dataSource titleForError:self.error];
        NSString	*subtitle	= [_dataSource subtitleForError:self.error];
        UIImage		*image		= [_dataSource imageForError:self.error];
        BOOL        executable  = [_dataSource buttonErrorExecutable];

        if (title.length || subtitle.length || image) {
            WXErrorView *errorView = [[WXErrorView alloc]	initWithTitle	:title
                                                              subtitle		:subtitle
                                                                 image		:image];
            errorView.backgroundColor	= self.view.backgroundColor;
            self.errorView				= errorView;
            if (executable && title) {
                [errorView addTarget:self action:@selector(emptyViewButtonAction)];
            }
            
        } else {
            self.errorView = nil;
        }
    } else {
        self.errorView = nil;
    }
}

- (void)showEmpty:(BOOL)show
{
    if (show) {
        NSString	*title		= [_dataSource titleForEmpty];
        NSString	*subtitle	= [_dataSource subtitleForEmpty];
        UIImage		*image		= [_dataSource imageForEmpty];
        UIImage     *titleImage = [_dataSource titleImageForEmpty];
        BOOL        executable  = [_dataSource buttonExecutable];
        
        if (title.length || subtitle.length || image) {
            WXErrorView *emptyView = [[WXErrorView alloc]	initWithTitle:title
                                                               subtitle:subtitle
                                                             titleImage:titleImage
                                                         watermarkImage:image];
            if (executable && title) {
                [emptyView addTarget:self action:@selector(emptyViewButtonAction)];
            }
            self.emptyView				= emptyView;
            
        } else {
            self.emptyView = nil;
        }
    }else{
        self.emptyView = nil;
    }
}



- (void)search:(NSString*)kw
{
    
}

- (void)cancelSearch
{
    
}

#pragma mark -
#pragma mark Public
- (void)createModel
{
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
//- (UITableView*)tableView {
//    if (nil == _tableView) {
//        _tableView = [[XYBaseTableView alloc] initWithFrame:CGRectZero style:_tableViewStyle];
//        _tableView.frame = self.view.bounds;
//        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth
//        | UIViewAutoresizingFlexibleHeight;
//        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.showsHorizontalScrollIndicator = NO;
//
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}


- (void)setTableView:(UITableView*)tableView {
    if (tableView != _tableView) {
        
        if (_tableView) {
            [_tableView removeFromSuperview];
            _tableView = nil;
        }
        
        if (tableView == nil) {
            _tableView = nil;
            self.tableOverlayView = nil;
        }else {
            _tableView = tableView;
            _tableView.delegate = nil;
            _tableView.delegate = self;
            _tableView.dataSource = self.dataSource;
            
            if (!_tableView.superview) {
                [self.view addSubview:_tableView];
            }
        }
    }
}

- (void)setTableOverlayView:(UIView*)tableOverlayView animated:(BOOL)animated {
    if (tableOverlayView != _tableOverlayView) {
        if (_tableOverlayView) {
            if (animated) {
                [self fadeOutView:_tableOverlayView];
                
            } else {
                [_tableOverlayView removeFromSuperview];
            }
        }
        
        _tableOverlayView=nil;
        _tableOverlayView = tableOverlayView;
        
        if (_tableOverlayView) {
            _tableOverlayView.frame = [self rectForOverlayView];
            [self addToOverlayView:_tableOverlayView];
        }
        
        // XXXjoe There seem to be cases where this gets left disable - must investigate
        //_tableView.scrollEnabled = !_tableOverlayView;
    }
}

- (void)setTableWatermarkView:(UIView *)tableWatermarkView animated:(BOOL)animated{
    if (tableWatermarkView != _tableWatermarkView) {
        if (_tableWatermarkView) {
            if (animated) {
                [self fadeOutView:_tableWatermarkView];
                
            } else {
                [_tableWatermarkView removeFromSuperview];
            }
        }
        
        _tableWatermarkView = nil;
        _tableWatermarkView = tableWatermarkView;
        
        if (_tableWatermarkView) {
            _tableWatermarkView.frame = [self rectForWatermarkView];
            [self addToWatermarkView:_tableWatermarkView];
        }
        
        // XXXjoe There seem to be cases where this gets left disable - must investigate
        //_tableView.scrollEnabled = !_tableOverlayView;
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDataSource:(id<WXTableViewDataSource>)dataSource {
    if (dataSource != _dataSource) {
        _dataSource = nil;
        _dataSource = dataSource;
        _tableView.dataSource = _dataSource;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLoadingView:(UIView*)view {
    if (view != _loadingView) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
            _loadingView = nil;
        }
        _loadingView = view;
        if (_loadingView) {
            [self addToWatermarkView:_loadingView];
            
        } else {
            [self resetWatermarkView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorView:(UIView*)view {
    if (view != _errorView) {
        if (_errorView) {
            [_errorView removeFromSuperview];
            _errorView = nil;
        }
        _errorView = view;
        
        if (_errorView) {
            [self addToWatermarkView:_errorView];
            
        } else {
            [self resetWatermarkView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEmptyView:(UIView*)view {
    if (view != _emptyView) {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        _emptyView = view;
        if (_emptyView) {
            [self addToWatermarkView:_emptyView];
            
        } else {
            [self resetWatermarkView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    
    if ([object isKindOfClass:[WXTableViewLoadMoreItem class]] && !self.loadingData) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            WXTableViewLoadMoreItem *moreItem = (WXTableViewLoadMoreItem *)object;
            moreItem.isLoading = YES;
            WXTableViewLoadMoreCell *cell = (WXTableViewLoadMoreCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            cell.animating = YES;
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self loadMoreAction];
        });
    }
}

- (void)willDisplayCell:(UITableViewCell*)cell Object:(id)object atIndexPath:(NSIndexPath*)indexPath{
    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didBeginDragging {
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didEndDragging {
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)rectForOverlayView {
    CGRect frame = self.view.frame;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if ([window findFirstResponder]) {
        frame.size.height -= 216.0f;
    }
    
    return frame;
}
- (CGRect)rectForWatermarkView {
    CGRect frame = self.view.frame;
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if ([window findFirstResponder]) {
        frame.size.height -= 216.0f;
    }
    
    return frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)pullToRefreshAction
{
    [self showLoading:YES];
}
- (void)infiniteScrollingAction
{
    //    [self showLoading:YES];
}
- (void)loadMoreAction
{}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)stopRefreshAction{
   // self.tableView.pullToRefreshView.lastUpdatedDate = [NSDate date];
    //[self.tableView.pullToRefreshView stopAnimating];
     [self.tableView.mj_header endRefreshing];
}

- (void)startRefreshAction {
    //[self.tableView.pullToRefreshView startAnimating];
    [self.tableView.mj_header beginRefreshing];
}
- (void)stopFooterRefresh
{
    [self.tableView.mj_footer endRefreshing];
}

- (void)refreshTable
{
    if (![self isViewLoaded]) {
        return;
    }
    [self.tableView reloadData];
    
    [self showLoading:NO];
    [self showError:NO];
    [self showEmpty:[self.dataSource empty]];
    [self stopRefreshAction];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)emptyViewButtonAction{
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////
@end

@implementation WXTableViewController (delegate)

#pragma mark - UIScrollViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self didBeginDragging];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self didEndDragging];
}

#pragma mark - UITableViewDelegate
///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    id<WXTableViewDataSource> dataSource = (id<WXTableViewDataSource>)tableView.dataSource;
    
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:tableView cellClassForObject:object];
    
    return [cls tableView:tableView rowHeightForObject:object];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
        NSString *title = [tableView.dataSource tableView:tableView
                                  titleForHeaderInSection:section];
        if (!title.length) {
            return 0;
        }
        return 22.0;
    }
    return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// 自定义sectionView在继承的controller中自己实现
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return nil;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * When the user taps a cell item, we check whether the tapped item has an attached URL and, if
 * it has one, we navigate to it. This also handles the logic for "Load more" buttons.
 */
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    id<WXTableViewDataSource> dataSource = (id<WXTableViewDataSource>)tableView.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    [self didSelectObject:object atIndexPath:indexPath];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<WXTableViewDataSource> dataSource = (id<WXTableViewDataSource>)tableView.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    [self willDisplayCell:(UITableViewCell *)cell  Object:object atIndexPath:indexPath];
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Similar logic to the above. If the user taps an accessory item and there is an associated URL,
 * we navigate to that URL.
 */
- (void)tableView:(UITableView*)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath*)indexPath {
    id<WXTableViewDataSource> dataSource = (id<WXTableViewDataSource>)tableView.dataSource;
    id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    WXLog(@" object:%@",object);
    //    if ([object isKindOfClass:[TTTableLinkedItem class]]) {
    //        TTTableLinkedItem* item = object;
    //        if (item.accessoryURL && [_controller shouldOpenURL:item.accessoryURL]) {
    //            TTOpenURLFromView(item.accessoryURL, tableView);
    //        }
    //    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.loadingData) {
        return;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat contentFoot = scrollView.contentSize.height - offsetY;
    CGFloat viewHeight	= scrollView.frame.size.height;
    
    //有一种情况下，contentFoot正好比viewHeight多一点，导致不能正常加载
    if (contentFoot <= viewHeight + 1.0f) {
        // 最后一项为加载更多
        int lastSectionIndex = 0;
        
        if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
            int sectionNumber = (int)[self.dataSource numberOfSectionsInTableView:self.tableView];
            
            if (sectionNumber > 0) {
                lastSectionIndex = sectionNumber - 1;
            }
        }
        
        int lastRowIndex = 0;
        
        if ([self.dataSource tableView:self.tableView numberOfRowsInSection:lastSectionIndex] > 0) {
            lastRowIndex = (int)[self.dataSource tableView:self.tableView numberOfRowsInSection:lastSectionIndex] - 1;
        }
        
        NSIndexPath *lastRowIndexPath	= [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
        id			object				= [self.dataSource tableView:self.tableView objectForRowAtIndexPath:lastRowIndexPath];
        
        if ([object isKindOfClass:[WXTableViewLoadMoreItem class]]) {
            [self didSelectObject:object atIndexPath:lastRowIndexPath];
        }
    }
    if (offsetY <= 40.0f) {
        // 第一项为加载更多
        NSIndexPath *lastRowIndexPath	= [NSIndexPath indexPathForRow:0 inSection:0];
        id			object				= [self.dataSource tableView:self.tableView objectForRowAtIndexPath:lastRowIndexPath];
        
        if ([object isKindOfClass:[WXTableViewLoadMoreItem class]]) {
            [self didSelectObject:object atIndexPath:lastRowIndexPath];
        }
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    // 第一项为加载更多
    NSIndexPath *lastRowIndexPath	= [NSIndexPath indexPathForRow:0 inSection:0];
    id			object				= [self.dataSource tableView:self.tableView objectForRowAtIndexPath:lastRowIndexPath];
    
    if ([object isKindOfClass:[WXTableViewLoadMoreItem class]]) {
        [self didSelectObject:object atIndexPath:lastRowIndexPath];
    }
}

/**
	为了添加星云背景标记图做的操作
 */
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if (scrollView.contentOffset.y < -200) {
    //        [UIView beginAnimations:nil context:NULL];
    //        [UIView setAnimationDuration:0.4];
    //        [scrollView setContentOffset:CGPointMake(0, -200)];
    //        [UIView commitAnimations];
    //    }
    //    if (self.isShowXingYunBackView) {
    //        float offset_y = scrollView.contentOffset.y;
    //        if (offset_y >= 0 ) {//&& self.tableView.backgroundView.top >0
    //            [UIView animateWithDuration:0.01 animations:^{
    //                _tableviewBackview.top = 0;
    //            }];
    //        }else{
    //            [UIView animateWithDuration:0.01 animations:^{
    //                _tableviewBackview.top = -offset_y;
    //            }];
    //            
    //        }
    //    }
}
 */

- (MJRefreshNormalHeader*)installHeader{
    
    //    [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        //        //Call this Block When enter the refresh status automatically
    //        //    }]
    
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullToRefreshAction)];
    
    // Enter the refresh status immediately
    [self.tableView.mj_header beginRefreshing];
    
    //    [header setTitle:@"下拉开始刷新" forState:MJRefreshStateIdle];
    //
    //    [header setTitle:@"松开开始刷新" forState:MJRefreshStatePulling];
    //
    //    [header setTitle:@"数据加载中 ..." forState:MJRefreshStateRefreshing];
    
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    
    header.lastUpdatedTimeLabel.textColor = [UIColor darkGrayColor];
    return header;
}
- (MJRefreshAutoNormalFooter*)installFooter
{
    MJRefreshAutoNormalFooter * footerView =  [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAction)];
    
    [footerView setTitle:@"" forState:MJRefreshStateIdle];
    [footerView setTitle:@"数据加载中 ..." forState:MJRefreshStateRefreshing];
    
    return footerView;
}
@end
