//
//  XYPullToRefreshImageview.h
//  XYCore
//
//  Created by sunyuping on 13-3-5.
//  Copyright (c) 2013年 Xingyun.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum XYPullToRefreshImageViewState {
    XYPullToRefreshImageViewStateNone = 1,
    XYPullToRefreshImageViewStateTriggered,
    XYPullToRefreshImageViewStateLoading
}XYPullToRefreshImageViewState;


@interface XYPullToRefreshImageview : UIView{
    UIImageView *_arrowImageView;
    XYPullToRefreshImageViewState _currentState;
}
@property (nonatomic,assign)XYPullToRefreshImageViewState currentState;
@property (nonatomic,strong) UIImageView *arrowImageView;
-(void)setArrowTransform:(BOOL)isUp;
-(void)setPullProgress:(float)progress;
-(void)startloading;
-(void)renewState;


@end
