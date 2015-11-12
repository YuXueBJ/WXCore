//
//  WXBaseTableView.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXBaseTableView.h"

static const CGFloat kShadowHeight        = 20.0;
static const CGFloat kShadowInverseHeight = 10.0;

@implementation WXBaseTableView

@synthesize contentOrigin     = _contentOrigin;
@synthesize showShadows       = _showShadows;
//@synthesize showsVerticalScrollIndicator;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
    }
    
    return self;
}


//-(void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator{
//    [super setShowsHorizontalScrollIndicator:showsVerticalScrollIndicator];
//
//
//
//}
//-(BOOL)showsVerticalScrollIndicator{
//    return [super showsVerticalScrollIndicator];
//}
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIScrollView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setContentSize:(CGSize)size {
    if (_contentOrigin) {
        CGFloat minHeight = self.frame.size.height + _contentOrigin;
        if (size.height < minHeight) {
            size.height = self.frame.size.height + _contentOrigin;
        }
    }
    
    CGFloat y = self.contentOffset.y;
    [super setContentSize:size];
    
    if (_contentOrigin) {
        // As described below in setContentOffset, UITableView insists on messing with the
        // content offset sometimes when you change the content size or the height of the table
        self.contentOffset = CGPointMake(0, y);
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setContentOffset:(CGPoint)point {
    // UITableView (and UIScrollView) are really stupid about resetting the content offset
    // when the table view itself is resized.  There are times when I scroll to a point and then
    // disable scrolling, and I don't want the table view scrolling somewhere else just because
    // it was resized.
    if (self.scrollEnabled) {
        if (!(_contentOrigin && self.contentOffset.y == _contentOrigin && point.y == 0)) {
            [super setContentOffset:point];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)reloadData {
    // -[UITableView reloadData] takes away first responder status if the first responder is a
    // subview, so remember it and then restore it afterward to avoid awkward keyboard disappearance
    UIResponder* firstResponder = [self.window findFirstResponderInView:self];
    
    CGFloat y = self.contentOffset.y;
    [super reloadData];
    
    if (nil != firstResponder) {
        [firstResponder becomeFirstResponder];
    }
    
    if (_contentOrigin) {
        self.contentOffset = CGPointMake(0, y);
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
              scrollPosition:(UITableViewScrollPosition)scrollPosition {
    
    [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:scrollPosition];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CAGradientLayer*)shadowAsInverse:(BOOL)inverse {
    CAGradientLayer* newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0.0, 0.0,
                                       self.frame.size.width,
                                       inverse ? kShadowInverseHeight : kShadowHeight);
    newShadow.frame = newShadowFrame;
    
    CGColorRef darkColor = [UIColor colorWithRed:0.0
                                           green:0.0
                                            blue:0.0
                                           alpha:inverse ?
                            (kShadowInverseHeight / kShadowHeight) * 0.5
                                                : 0.5].CGColor;
    CGColorRef lightColor = [self.backgroundColor
                             colorWithAlphaComponent:0.0].CGColor;
    
    newShadow.colors = [NSArray arrayWithObjects:
                        (__bridge id)(inverse ? lightColor : darkColor),
                        (__bridge id)(inverse ? darkColor : lightColor),
                        nil];
    return newShadow;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    return;
    //    if (!_showShadows || UITableViewStylePlain != self.style) {
    //        return;
    //    }
    //
    //    // Initialize the shadow layers.
    //    if (nil == _originShadow) {
    //        _originShadow = [self shadowAsInverse:NO];
    //        [self.layer insertSublayer:_originShadow atIndex:0];
    //
    //    } else if (![[self.layer.sublayers objectAtIndex:0] isEqual:_originShadow]) {
    //        [_originShadow removeFromSuperlayer];
    //        [self.layer insertSublayer:_originShadow atIndex:0];
    //    }
    //
    //    [CATransaction begin];
    //    [CATransaction setValue: (id)kCFBooleanTrue
    //                     forKey: kCATransactionDisableActions];
    //
    //    CGRect originShadowFrame = _originShadow.frame;
    //    originShadowFrame.size.width = self.frame.size.width;
    //    originShadowFrame.origin.y = self.contentOffset.y;
    //    _originShadow.frame = originShadowFrame;
    //
    //    [CATransaction commit];
    //
    //    // Remove the table cell shadows if there aren't any cells.
    //    NSArray* indexPathsForVisibleRows = [self indexPathsForVisibleRows];
    //    if (0 == [indexPathsForVisibleRows count]) {
    //        [_topShadow removeFromSuperlayer];
    //        RELEASE(_topShadow);
    //
    //        [_bottomShadow removeFromSuperlayer];
    //        RELEASE(_bottomShadow);
    //        return;
    //    }
    //
    //    // Assumptions at this point: There are cells.
    //    NSIndexPath* firstRow = [indexPathsForVisibleRows objectAtIndex:0];
    //
    //    // Check whether or not the very first row is visible.
    //    if (0 == [firstRow section]
    //        && 0 == [firstRow row]) {
    //        UIView* cell = [self cellForRowAtIndexPath:firstRow];
    //
    //        // Create the top shadow if necessary.
    //        if (nil == _topShadow) {
    //            _topShadow = [[self shadowAsInverse:YES] retain];
    //            [cell.layer insertSublayer:_topShadow atIndex:0];
    //
    //        }  else if ([cell.layer.sublayers indexOfObjectIdenticalTo:_topShadow] != 0) {
    //            [_topShadow removeFromSuperlayer];
    //            [cell.layer insertSublayer:_topShadow atIndex:0];
    //        }
    //
    //        CGRect shadowFrame = _topShadow.frame;
    //        shadowFrame.size.width = cell.frame.size.width;
    //        shadowFrame.origin.y = -kShadowInverseHeight;
    //        _topShadow.frame = shadowFrame;
    //
    //    } else {
    //        [_topShadow removeFromSuperlayer];
    //        RELEASE(_topShadow);
    //    }
    //
    //    NSIndexPath* lastRow = [indexPathsForVisibleRows lastObject];
    //
    //    // Check whether or not the very last row is visible.
    //    if ([lastRow section] == [self numberOfSections] - 1
    //        && [lastRow row] == [self numberOfRowsInSection:[lastRow section]] - 1) {
    //        UIView* cell = [self cellForRowAtIndexPath:lastRow];
    //
    //        if (nil == _bottomShadow) {
    //            _bottomShadow = [[self shadowAsInverse:NO] retain];
    //            [cell.layer insertSublayer:_bottomShadow atIndex:0];
    //
    //        }  else if ([cell.layer.sublayers indexOfObjectIdenticalTo:_bottomShadow] != 0) {
    //            [_bottomShadow removeFromSuperlayer];
    //            [cell.layer insertSublayer:_bottomShadow atIndex:0];
    //        }
    //
    //        CGRect shadowFrame = _bottomShadow.frame;
    //        shadowFrame.size.width = cell.frame.size.width;
    //        shadowFrame.origin.y = cell.frame.size.height;
    //        _bottomShadow.frame = shadowFrame;
    //        
    //    } else {
    //        [_bottomShadow removeFromSuperlayer];
    //        RELEASE(_bottomShadow);
    //    }
}

@end
