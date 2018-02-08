//
//  UIImage+Extra.h
//  
//
//  Created by shenjianguo on 10-8-3.
//  Copyright 2010 roosher. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (UIImageExtra)


+ (UIImage *)retina4ImageNamed:(NSString *)name;

+ (UIImage*)resizebleImageNamed:(NSString*)name;
+ (UIImage*)resizebleImageNamed:(NSString*)name insets:(UIEdgeInsets)insets;

+ (UIImage*)imageWithName:(NSString*)name size:(CGSize)size;

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;

+ (UIImage*)imageWithView:(UIView*)view;

+ (UIImage*)circleImageWithName:(NSString*)name;
+ (UIImage*)circelImageWithImage:(UIImage*)image;

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+(UIImage *)scaleToSizeImg:(UIImage *)img scalRation:(CGFloat)scal;

//转化成圆角
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius;
- (UIImage*)addImageText:(UIImage*)img text:(NSString*)text;
@end
