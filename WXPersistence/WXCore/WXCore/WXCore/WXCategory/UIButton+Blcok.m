//
//  UIButton+Blcok.m
//  OC_TestDemo
//
//  Created by 朱洪伟 on 15/8/7.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "UIButton+Blcok.h"

@implementation UIButton(Blcok)

static char ovierviewkey;
@dynamic event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)block
{
    objc_removeAssociatedObjects(self);
    objc_setAssociatedObject(self, &ovierviewkey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(selectorButton:) forControlEvents:controlEvent];
}
- (void)selectorButton:(id)sender
{
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &ovierviewkey);
    if (block) {
        block(self);
    }
}
@end
