//
//  WXBaseViewController.h
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXBaseViewController : UIViewController

+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target title:(NSString *)title action:(SEL)action;
+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target action:(SEL)action;
- (void)setNavigationTitleView:(NSString*)title;
- (void)setNavigationBlockTitleView:(NSString*)title;
- (void)setRightButtonItemEnable:(BOOL)enable;
- (void)goBack ;
- (void)goDismissBack;
@end
