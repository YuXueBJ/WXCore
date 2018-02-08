//
//  WXSearchDisplayController.h
//  WXCore
//
//  Created by 朱洪伟 on 15/10/24.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXTableViewController;

@protocol WXSearchDisplayControllerDelegate <NSObject>
@optional
- (void)willBeginSearch;
- (void)willEndSearch;
- (void)willHideSearchResult;
- (void)didShowResult;
@end

@interface WXSearchDisplayController : UISearchDisplayController<UISearchDisplayDelegate>

@property (nonatomic, retain) WXTableViewController * searchResultsViewController;

@property (nonatomic, assign) BOOL isHiddenNavigationBar;
@end
