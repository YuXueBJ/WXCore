//
//  DACircularProgressView.h
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DACircularProgressView : UIView

@property(nonatomic, strong) UIColor *trackTintColor;
@property(nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic) float progress;
@property (nonatomic, strong)NSTimer *anmitationTimer;
@property (nonatomic) float pathWidth;
@property (nonatomic) BOOL isCounterclockwise;
-(void)startAutoChange;
-(void)stopAutoChange;
@end
