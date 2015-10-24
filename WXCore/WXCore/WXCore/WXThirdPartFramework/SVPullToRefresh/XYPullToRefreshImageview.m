//
//  XYPullToRefreshImageview.m
//  XYCore
//
//  Created by sunyuping on 13-3-5.
//  Copyright (c) 2013年 Xingyun.cn. All rights reserved.
//

#import "XYPullToRefreshImageview.h"
#import <QuartzCore/QuartzCore.h>
@implementation XYPullToRefreshImageview

@synthesize currentState = _currentState;
@synthesize arrowImageView = _arrowImageView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *pullImage = [UIImage imageNamed:@"pull_refresh"];
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, pullImage.size.width, pullImage.size.height)];
        [_arrowImageView setImage:pullImage];
        [self addSubview:_arrowImageView];
        _currentState = XYPullToRefreshImageViewStateNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appactive) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}
-(void)renewState{
    [_arrowImageView.layer removeAllAnimations];
    _currentState = XYPullToRefreshImageViewStateNone;
    
}
-(void)setArrowTransform:(BOOL)isUp{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.1];
//    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    CGAffineTransform at = CGAffineTransformIdentity;//CGAffineTransformMakeRotation(M_PI*progress/10);
//    if (isUp) {
//        at = CGAffineTransformMakeRotation(M_PI);
//    }
//    [_arrowImageView setTransform:at];
//    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_arrowImageView cache:YES];
//    [UIView commitAnimations];
}
-(void)setPullProgress:(float)progress{

    if (_arrowImageView && _currentState != XYPullToRefreshImageViewStateLoading) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGAffineTransform at =CGAffineTransformMakeRotation(M_PI*progress/75);
        [_arrowImageView setTransform:at];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_arrowImageView cache:YES];
        [UIView commitAnimations];
    }
    
}
-(void)startloading{
    if (_arrowImageView) {
        _currentState = XYPullToRefreshImageViewStateLoading;
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.repeatCount = HUGE_VALF;
//        rotationAnimation.autoreverses = YES;
        //rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_arrowImageView.layer addAnimation:rotationAnimation forKey:nil];
    }
}
-(void)appactive{
    if (_currentState == XYPullToRefreshImageViewStateLoading) {
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        rotationAnimation.duration = 1.0f;
        rotationAnimation.repeatCount = HUGE_VALF;
        //        rotationAnimation.autoreverses = YES;
        //rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_arrowImageView.layer addAnimation:rotationAnimation forKey:nil];
    }    
}
@end
