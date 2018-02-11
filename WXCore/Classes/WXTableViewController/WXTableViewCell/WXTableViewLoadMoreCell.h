//
//  WXTableViewLoadMoreCell.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXTableViewCell.h"

@interface WXTableViewLoadMoreCell : WXTableViewCell{
    BOOL					_animating;
}
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong)  UIActivityIndicatorView * loadingAnimationView;
@property (nonatomic, strong)  UILabel * moreTextLabel;


- (void)resetLoadingAnimationView:(UIActivityIndicatorView*)loadingView;
@end
