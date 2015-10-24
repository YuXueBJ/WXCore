//
//  WXTableViewLoadMoreCell.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewCell.h"

@interface WXTableViewLoadMoreCell : WXTableViewCell
{
    UIActivityIndicatorView *_loadingAnimationView;
    UILabel					*_titleLabel;
    BOOL					_animating;
    XYPullToRefreshImageview *_refreshView;
}
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, retain) XYPullToRefreshImageview *refreshView;
- (void)resetLoadingAnimationView:(UIActivityIndicatorView*)loadingView;
@end
