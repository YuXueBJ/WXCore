//
//  MBHudUtil.m
//  djApp
//
//  Created by libin.tian on 1/6/14.
//  Copyright (c) 2014 dajie.com. All rights reserved.
//

#import "MBHudUtil.h"

#import "MBProgressHUD.h"
#import "UIImage+Extra.h"

@implementation LoadingView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self != nil) {
        
        UIImage* image = [UIImage imageNamed:@"window_loading.png"];
        _loadingImage = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_loadingImage];
        
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        _rotationAnimation.duration = 1.0f;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = MAXFLOAT;
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.loadingImage.centerX = self.width / 2.0f;
//    self.loadingImage.centerY = self.height / 2.0f;
}

- (void)startAnimating
{
    [self.loadingImage.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

@end

@implementation MBHudUtil

+ (UIView*)defaultView
{
    UIWindow* window = [UIApplication sharedApplication].delegate.window;
    return window;
}

+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+ (void)showActivityInView:(UIView *)view
{
    [self showActivityView:nil inView:view];
}
+ (void)showActivityView:(NSString *)text
                  inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    MBProgressHUD * hud = (MBProgressHUD *)viewExist;
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.removeFromSuperViewOnHide = YES;
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
}
+ (void)showActivityText:(NSString *)text
                 interval:(NSTimeInterval)time
                  inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
    for (UIView *v in [view subviews]) {
        if ([v isKindOfClass:[MBProgressHUD class]]) {
            viewExist = v;
            break;
        }
    }
    
    MBProgressHUD * hud = (MBProgressHUD *)viewExist;
    if (hud == nil) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.removeFromSuperViewOnHide = YES;
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    [hud hide:YES afterDelay:time];

}


+ (void)hideActivityView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];

}

+ (void)showFinishActivityView:(NSString *)text
{
    [self showFinishActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval];
}

+ (void)showFinishActivityView:(NSString *)text
                        inView:(UIView *)view
{
    [self showFinishActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval
                          inView:view];
}


+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
{
    [self showFinishActivityView:text
                        interval:time
                          inView:nil];
}

+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
    }
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeCustomView;
//    [HUD hideAnimated:YES afterDelay:time];
    [HUD hide:YES afterDelay:time];
}
+ (void)showCollectActivityView:(NSString *)imageName
                       interval:(NSTimeInterval)time
                         inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
    for (UIView *v in [view subviews]) {
        if ([v isKindOfClass:[MBProgressHUD class]]) {
            viewExist = v;
            break;
        }
    }
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
    }
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView.backgroundColor = [UIColor clearColor];
//    [HUD hideAnimated:YES afterDelay:time];
    [HUD hide:YES afterDelay:time];
}
+ (void)showCancelCollectActivityView:(NSString *)text
                             interval:(NSTimeInterval)time
                               inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView *viewExist = nil;
    for (UIView *v in [view subviews]) {
        if ([v isKindOfClass:[MBProgressHUD class]]) {
            viewExist = v;
            break;
        }
    }
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
    }
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quxiaoshoucang"]];
    HUD.mode = MBProgressHUDModeCustomView;
//    [HUD hideAnimated:YES afterDelay:time];
    [HUD hide:YES afterDelay:time];
}


+ (void)showFailedActivityView:(NSString *)text
{
    [self showFailedActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval];
}

+ (void)showFailedActivityView:(NSString *)text
                        inView:(UIView *)view
{
    [view  endEditing:YES];
    [self showFailedActivityView:text
                        interval:Http_ErrorMsgDisplay_Interval
                          inView:view];
}

+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
{
    [self showFailedActivityView:text
                        interval:time
                          inView:nil];
}


+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view
{
    if (view == nil) {
        view = [self defaultView];
    }
    UIView * viewExist = nil;
	for (UIView *v in [view subviews]) {
		if ([v isKindOfClass:[MBProgressHUD class]]) {
			viewExist = v;
            break;
		}
	}
    
    MBProgressHUD *HUD = (MBProgressHUD *)viewExist;
    if (HUD == nil) {
        HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
    }
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_error"]];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeCustomView;
//    [HUD hideAnimated:YES afterDelay:time];
    [HUD hide:YES afterDelay:time];

}

+ (void)showAlert:(NSString*)msg
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [[self getCurrentVC] presentViewController:alert animated:true completion:nil];
}
+ (void)showAlert:(NSString*)msg showVc:(UIViewController*)vc
{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:  UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
    }]];
    //弹出提示框；
    [vc presentViewController:alert animated:true completion:nil];
}
+ (void)showAlert:(NSString*)msg showVc:(UIViewController*)vc handler:(void (^ __nullable)(UIAlertAction *action))handler{
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:  UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:handler]];
    //弹出提示框；
    [vc presentViewController:alert animated:true completion:nil];
}
+(void)showAlertAttributeMessage:(NSAttributedString *)attributeMessage delegate:(id) delegate okButtonTitle:(NSString *)title inView:(UIView *)view
{
    NSMutableAttributedString *sttributeString;
    if (attributeMessage) {
        sttributeString = [[NSMutableAttributedString alloc] initWithAttributedString:attributeMessage];
    }else{
        sttributeString = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    
    NSString *buttonTitle;
    if ([title length] != 0) {
        buttonTitle = title;
    }else{
        buttonTitle =  @"知道了";
    }
    
    UIView *containerView;
    if (!view) {
        containerView = [self defaultView];
    }else{
        containerView = view;
    }

//    MessageBoxView *messageBoxView = [MessageBoxView shareInstance];
//    messageBoxView.attributeMessage = sttributeString;
//    messageBoxView.buttonTitle = buttonTitle;
//    [containerView addSubview:messageBoxView];
//    
//    if (delegate) {
//        messageBoxView.delegate = delegate;
//    }

}


+(void)showAlertMessage:(NSString *)message;
{
    NSAttributedString *attributeMessage = [[NSAttributedString alloc] initWithString:message];
    [self showAlertAttributeMessage:attributeMessage delegate:nil okButtonTitle:nil inView:nil];
}
+(void)showAlertMessage:(NSString *)message  delegate:(id) delegate okButtonTitle:(NSString *)title inView:(UIView *)view
{
    NSAttributedString *attributeMessage = [[NSAttributedString alloc] initWithString:message];
    [self showAlertAttributeMessage:attributeMessage delegate:delegate okButtonTitle:title inView:view];
}
+(void)showAlertAttributeMessage:(NSAttributedString *)attributeMessage
{
    [self showAlertAttributeMessage:attributeMessage delegate:nil okButtonTitle:nil inView:nil];
}


@end
