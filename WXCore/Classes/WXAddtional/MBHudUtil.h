//
//  MBHudUtil.h
//  djApp
//
//  Created by libin.tian on 1/6/14.
//  Copyright (c) 2014 dajie.com. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat Http_ErrorMsgDisplay_Interval = 15.f;
@interface LoadingView : UIView
@property (nonatomic, strong) UIImageView * loadingImage;
@property (nonatomic, strong) CABasicAnimation* rotationAnimation;
- (void)startAnimating;
@end

@interface MBHudUtil : NSObject

+ (void)showActivityInView:(UIView *)view;

+ (void)showActivityView:(NSString *)text
                  inView:(UIView *)view;

+ (void)hideActivityView:(UIView *)view;

+ (void)showFinishActivityView:(NSString *)text;

+ (void)showFinishActivityView:(NSString *)text
                        inView:(UIView *)view;
+ (void)showActivityText:(NSString *)text
                interval:(NSTimeInterval)time
                  inView:(UIView *)view;

+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time;

+ (void)showFinishActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view;

+ (void)showFailedActivityView:(NSString *)text;

+ (void)showFailedActivityView:(NSString *)text
                        inView:(UIView *)view;

+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time;

+ (void)showFailedActivityView:(NSString *)text
                      interval:(NSTimeInterval)time
                        inView:(UIView *)view;

+ (void)showCollectActivityView:(NSString *)imageName
                       interval:(NSTimeInterval)time
                         inView:(UIView *)view;

+ (void)showCancelCollectActivityView:(NSString *)text
                       interval:(NSTimeInterval)time
                         inView:(UIView *)view;

+ (void)showAlert:(NSString*)msg;
+ (void)showAlert:(NSString*)msg showVc:(UIViewController*)vc;
+ (void)showAlert:(NSString*)msg showVc:(UIViewController*)vc handler:(void (^ __nullable)(UIAlertAction *action))handler;

+(void)showAlertMessage:(NSString *)message;
+(void)showAlertMessage:(NSString *)message  delegate:(id) delegate okButtonTitle:(NSString *)title inView_Nullable_Nullable:(UIView *)view;
+(void)showAlertAttributeMessage:(NSAttributedString *)attributeMessage;

+(void)showAlertAttributeMessage:(NSAttributedString *)attributeMessage delegate:(id) delegate okButtonTitle:(NSString *)title inView_Nullable:(UIView *)view;

@end
