//
//  UIWindowAddition.m
//  SYPFrameWork
//
//  Created by 朱洪伟 on 15/8/7.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "UIWindowAddition.h"

@implementation UIWindow (WindowExt)
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponder {
    return [self findFirstResponderInView:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

@end
