//
//  RSPullToRefreshImageView.m
//  RenrenSixin
//
//  Created by sunyuping on 12-9-7.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RSPullToRefreshImageView.h"
#import <QuartzCore/QuartzCore.h>
@implementation RSPullToRefreshImageView

@synthesize currentState = _currentState;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // Initialization code
        _grayAngleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, frame.size.height)];
        [_grayAngleImageView setImage:[UIImage imageNamed:@"grayAngle.png"]];
       // [self addSubview:_grayAngleImageView];
        
        _grayCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_grayCircle setImage:[UIImage imageNamed:@"grayCircle.png"]];
        [self addSubview:_grayCircle];
        
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-19)/2,(frame.size.height-19)/2, 19, 19)];
        [_arrowImageView setImage:[UIImage imageNamed:@"arrow.png"]];
        [self addSubview:_arrowImageView];
        
        
        _blueAngleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, frame.size.width, frame.size.height)];
        [_blueAngleImageView setImage:[UIImage imageNamed:@"blueAngle.png"]];
        _blueAngleImageView.hidden = YES;
        //[self addSubview:_blueAngleImageView];
        
        
        _blueCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_blueCircle setImage:[UIImage imageNamed:@"blueCircle.png"]];
        _blueCircle.hidden = YES;
        [self addSubview:_blueCircle];
        
        _currentState = RSPullToRefreshImageViewStateNone;
    }
    return self;
}
-(void)renewState{
    [_arrowImageView setTransform:CGAffineTransformIdentity];
    [_grayCircle setTransform:CGAffineTransformIdentity];
    [_blueCircle setTransform:CGAffineTransformIdentity];
    [_blueCircle.layer removeAllAnimations];
    _arrowImageView.hidden = NO;
    _blueAngleImageView.hidden = YES;
    _blueCircle.hidden = YES;
    _grayCircle.hidden = NO;
    _grayAngleImageView.hidden = NO;
    _currentState = RSPullToRefreshImageViewStateNone;
    
}
-(void)setArrowTransform:(BOOL)isUp{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.1];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGAffineTransform at = CGAffineTransformIdentity;//CGAffineTransformMakeRotation(M_PI*progress/10);
    if (isUp) {
        at = CGAffineTransformMakeRotation(M_PI);
    }
    [_arrowImageView setTransform:at];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_arrowImageView cache:YES];
    [UIView commitAnimations];
}
-(void)setPullProgress:(float)progress{
    if (_grayCircle && _currentState != RSPullToRefreshImageViewStateLoading) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGAffineTransform at =CGAffineTransformMakeRotation(M_PI*progress/40);
        [_grayCircle setTransform:at];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_grayCircle cache:YES];
        [UIView commitAnimations];
    }
}
-(void)startloading{
    if (_blueCircle) {
        _currentState = RSPullToRefreshImageViewStateLoading;
        _arrowImageView.hidden = YES;
        _grayAngleImageView.hidden = YES;
        _grayCircle.hidden = YES;
        _blueAngleImageView.hidden = NO;
        _blueCircle.hidden = NO;
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
        rotationAnimation.duration = 0.4f;
        rotationAnimation.repeatCount = HUGE_VALF;
       // rotationAnimation.autoreverses = YES;
        //rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [_blueCircle.layer addAnimation:rotationAnimation forKey:nil];
    }
}

@end
