//
//  UIButton+Blcok.h
//  OC_TestDemo
//
//  Created by 朱洪伟 on 15/8/7.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef void (^ActionBlock)(id sender);

@interface UIButton (Blcok)

@property (readonly) NSMutableDictionary *event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)block;


@end
