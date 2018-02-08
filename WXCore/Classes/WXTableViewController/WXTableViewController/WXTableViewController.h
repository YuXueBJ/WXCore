//
//  WXTableViewController.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXBaseViewController.h"
#import "WXCode.h"

@class WXSearchDisplayController;

@interface WXTableViewController : WXBaseViewController
{
    UITableView*  _tableView;
    UIView*       _tableWatermarkView;
    UIView*       _tableOverlayView;
    UIView*       _loadingView;
    UIView*       _errorView;
    UIView*       _emptyView;
    
    NSTimer*      _bannerTimer;
    
    UITableViewStyle        _tableViewStyle;
    
    UIInterfaceOrientation  _lastInterfaceOrientation;
    
    BOOL _showTableShadows;
    
    WXTableViewDataSource *_dataSource;
    
    WXSearchDisplayController  *_searchController;

    
@private
    BOOL _shouldLoadTableView;
}

/**
	用于显示星云
 */
@property (nonatomic, assign) BOOL isShowXingYunBackView;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property (nonatomic, assign) BOOL showsInfiniteScrolling;

@property (nonatomic, retain) NSError *error;
@property (nonatomic, assign) BOOL loadingData;//默认是NO, 载入数据时为YES,主要防止load more多次使用
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) WXTableViewController *searchViewController;
@property (nonatomic, assign) BOOL removeSearchBarBackgroundColor; //删除_searchController的背景颜色，如果基类用到删除_searchController背景颜色的，设成YES,默认NO；为了避免基类内存紧张时重复删除背景，导致没有searchBar的bug
/**
 * A view that is displayed over the table view.
 */
@property (nonatomic, retain) UIView* tableOverlayView;
@property (nonatomic, retain) UIView* tableWatermarkView;

@property (nonatomic, retain) UIView* loadingView;
@property (nonatomic, retain) UIView* errorView;
@property (nonatomic, retain) UIView* emptyView;

/**
 * The data source used to populate the table view.
 *
 * Setting dataSource has the side effect of also setting model to the value of the
 * dataSource's model property.
 */
@property (nonatomic, retain) WXTableViewDataSource *dataSource;

/**
 * The style of the table view.
 */
@property (nonatomic) UITableViewStyle tableViewStyle;

/**
 * When enabled, draws gutter shadows above the first table item and below the last table item.
 *
 * Known issues: When there aren't enough cell items to fill the screen, the table view draws
 * empty cells for the remaining space. This causes the bottom shadow to appear out of place.
 */
@property (nonatomic) BOOL showTableShadows;

/**
 * Initializes and returns a controller having the given style.
 */
- (id)initWithStyle:(UITableViewStyle)style;

/**
 * Tells the controller that the user selected an object in the table.
 *
 * By default, the object's URLValue will be opened in TTNavigator, if it has one. If you don't
 * want this to be happen, be sure to override this method and be sure not to call super.
 */
- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

- (void)willDisplayCell:(UITableViewCell*)cell Object:(id)object atIndexPath:(NSIndexPath*)indexPath;


/**
 * Tells the controller that the user began dragging the table view.
 */
- (void)didBeginDragging;

/**
 * Tells the controller that the user stopped dragging the table view.
 */
- (void)didEndDragging;

/**
 * The rectangle where the overlay view should appear.
 */
- (CGRect)rectForOverlayView;
/**
 * 下拉刷新需要执行的方法
 */
- (void)pullToRefreshAction;
/**
 * 重置下拉刷新状态
 */
- (void)stopRefreshAction;
/**
 * 下拉刷新动画开始
 */
- (void)startRefreshAction;

/**
 * 上拉刷新需要执行得方法
 */
- (void)infiniteScrollingAction;
/**
 * 停止上拉刷新
 */
- (void)stopFooterRefresh;

- (void)refreshTable;

/**
 * emptyView 显示的时，点击button，需要执行的方法
 */
- (void)emptyViewButtonAction;

//状态显示
/**展示空页面*/
- (void)showEmpty:(BOOL)show;
/**展示加载转态*/
- (void)showLoading:(BOOL)show;
/*展示错误页面*/
- (void)showError:(BOOL)show;
/**
 * 搜索
 */
- (void)search:(NSString*)kw;
- (void)cancelSearch;
@end
