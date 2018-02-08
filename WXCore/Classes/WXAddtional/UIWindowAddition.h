//
//  UIWindowAddition.h
//  SYPFrameWork
//
//  Created by 朱洪伟 on 15/8/7.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIWindow (WindowExt)
/**
 * Searches the view hierarchy recursively for the first responder, starting with this window.
 */
- (UIView*)findFirstResponder;

/**
 * Searches the view hierarchy recursively for the first responder, starting with topView.
 */
- (UIView*)findFirstResponderInView:(UIView*)topView;


@end
