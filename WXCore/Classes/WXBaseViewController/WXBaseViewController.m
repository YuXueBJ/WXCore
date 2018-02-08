//
//  WXBaseViewController.m
//  WXCore
//
//  Created by 朱洪伟 on 15/7/9.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#import "WXBaseViewController.h"
#import "UIBarButtonItem+Image.h"
#import "ViewCreatorHelper.h"
#import "WXDefines.h"
#import "WXImage.h"

@interface WXBaseViewController ()

@end

@implementation WXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGBCOLOR(241, 241, 241);
    // 返回按钮
    [self setBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setBarButtonItem {
    NSInteger x = [self.navigationController.viewControllers count];
    if (x > 1) {// 多余一级的时候，再创建返回按钮
        self.navigationItem.leftBarButtonItem =
        [WXBaseViewController navigationBackButtonItemWithTarget:self action:@selector(goBack)];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
            returnButtonItem.title = @"";
            self.navigationItem.backBarButtonItem = returnButtonItem;
        } else {
            self.navigationItem.hidesBackButton = YES;
        }
    }
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goDismissBack {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)setNavigationTitleView:(NSString*)title
{
    CGRect rc=CGRectMake(0, 0, 63, 45);

    UILabel * titleLable = [ViewCreatorHelper createLabelWithTitle:title font:[UIFont systemFontOfSize:18.0f] frame:rc textColor:kDefaultHomeTextColor textAlignment:NSTextAlignmentLeft];
    [titleLable sizeToFit];
    self.navigationItem.titleView =  titleLable;
}
- (void)setNavigationBlockTitleView:(NSString*)title
{
    CGRect rc=CGRectMake(0, 0, 63, 45);
    
    UILabel * titleLable = [ViewCreatorHelper createLabelWithTitle:title font:[UIFont systemFontOfSize:18.0f] frame:rc textColor:kDefaultHomeBlockTextColor textAlignment:NSTextAlignmentLeft];
    [titleLable sizeToFit];
    self.navigationItem.titleView =  titleLable;
}
+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target title:(NSString *)title action:(SEL)action{
    
    UIImage *normalImage = [UIImage imageNamed:navBackImageName];
    UIImage *hlImage = [UIImage imageNamed:navBackImageName];
    UIBarButtonItem *buttonItem = [UIBarButtonItem rsBarButtonItemWithTitle:title
                                                                      image:normalImage
                                                           heightLightImage:hlImage
                                                               disableImage:nil
                                                                     target:target
                                                                     action:action];
    return buttonItem;
}
+ (UIBarButtonItem *)navigationBackButtonItemWithTarget:(id)target action:(SEL)action{
    UIImage * normalImage = [UIImage imageNamed:navBackImageName];
    UIImage * hlImage = [UIImage imageNamed:navBackImageName];
    UIBarButtonItem *buttonItem = [UIBarButtonItem rsBarButtonItemWithTitle:nil
                                                                      image:normalImage
                                                           heightLightImage:hlImage
                                                               disableImage:nil
                                                                     target:target
                                                                     action:action];
    return buttonItem;
}
- (void)setRightButtonItemEnable:(BOOL)enable {
    
    if (self.navigationItem.rightBarButtonItem == nil) {
        return;
    }
    
    NSArray *array = [self.navigationItem rightBarButtonItems];
    UIBarButtonItem *item = [array lastObject];
    UIButton *button = (UIButton *)item.customView;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button setEnabled:enable];
}


@end
