//
//  RSPullToRefreshImageView.h
//  RenrenSixin
//
//  Created by sunyuping on 12-9-7.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum RSPullToRefreshImageViewState {
    RSPullToRefreshImageViewStateNone = 1,
    RSPullToRefreshImageViewStateTriggered,
    RSPullToRefreshImageViewStateLoading
}RSPullToRefreshImageViewState;

@interface RSPullToRefreshImageView : UIView{
    
    UIImageView *_grayAngleImageView;
    UIImageView *_blueAngleImageView;
    UIImageView *_grayCircle;
    UIImageView *_blueCircle;
    UIImageView *_arrowImageView;
    RSPullToRefreshImageViewState _currentState;
    
}
@property (nonatomic,assign)RSPullToRefreshImageViewState currentState;

-(void)setArrowTransform:(BOOL)isUp;
-(void)setPullProgress:(float)progress;
-(void)startloading;
-(void)renewState;
@end
