//
//  UIImage+Extra.m
//  
//
//  Created by shenjianguo on 10-8-3.
//  Copyright 2010 roosher. All rights reserved.
//

#import "UIImage+Extra.h"

@implementation UIImage (UIImageExtra)
+ (UIImage *)retina4ImageNamed:(NSString *)name;
{
//    if (kIPhone5) {
//        NSMutableString *imageNameMutable = [name mutableCopy];
//        NSRange retinaAtSymbol = [name rangeOfString:@"@"];
//        if (retinaAtSymbol.location != NSNotFound) {
//            [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
//        } else {
//            NSRange dot = [name rangeOfString:@"."];
//            if (dot.location != NSNotFound) {
//                [imageNameMutable insertString:@"-568h" atIndex:dot.location];
//            } else {
//                [imageNameMutable appendString:@"-568h"];
//            }
//        }
//        UIImage *result = [UIImage imageNamed:imageNameMutable];
//        if (result) {
//            return result;
//        }
//    }
    return [UIImage imageNamed:name];
}


+ (UIImage*)resizebleImageNamed:(NSString*)name
{
    UIImage* result = nil;
    UIImage* image = [UIImage imageNamed:name];
    if (image != nil) {
        CGSize s = image.size;
        UIEdgeInsets inset = UIEdgeInsetsMake(s.height/2.0f-1, s.width/2.0f-1, s.height/2.0+1, s.width/2.0+1);
        result = [image resizableImageWithCapInsets:inset];
    }
    
    return result;
}

+ (UIImage*)resizebleImageNamed:(NSString*)name insets:(UIEdgeInsets)insets;
{
    UIImage* result = nil;
    UIImage* image = [UIImage imageNamed:name];
    if (image != nil) {
        result = [image resizableImageWithCapInsets:insets];
    }
    
    return result;
}

+ (UIImage*)imageWithName:(NSString*)name size:(CGSize)size
{
    UIImage* result = nil;
    UIImage* image = [UIImage imageNamed:name];
    if (image != nil) {
        CGSize s = image.size;
        UIEdgeInsets inset = UIEdgeInsetsMake(s.height/2.0f-1, s.width/2.0f-1, s.height/2.0+1, s.width/2.0+1);
        result = [image resizableImageWithCapInsets:inset];
        CGRect rc = CGRectZero;
        rc.size = size;
        if (rc.size.width < 0.5f) {
            rc.size.width = s.width;
        }
        if (rc.size.height < 0.5f) {
            rc.size.height = s.height;
        }
        UIImageView* view = [[UIImageView alloc] initWithFrame:rc];
        view.image = result;
        
        result = [self imageWithView:view];
    }
    
    return result;
}

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size
{
    CGRect frame = CGRectZero;
    
    BOOL resizeable = NO;
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(5.0f, 5.0f);
        resizeable = YES;
    }
    
    frame.size = size;
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (resizeable) {
        UIEdgeInsets inset = UIEdgeInsetsMake(size.height/2.0f-1, size.width/2.0f-1, size.height/2.0+1, size.width/2.0+1);
        UIImage* result = [image resizableImageWithCapInsets:inset];
        return result;
    }
    else {
        return image;
    }
}

+ (UIImage*)imageWithView:(UIView*)view
{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage*)circleImageWithName:(NSString*)name
{
    UIImage* img = [UIImage imageNamed:name];
    return [UIImage circelImageWithImage:img];
}

+ (UIImage*)circelImageWithImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *imgNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgNew;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+(UIImage *)scaleToSizeImg:(UIImage *)img scalRation:(CGFloat)scal
{
    CGSize size = CGSizeZero;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    if(scale_screen < 3){
        size = CGSizeMake(60, 60);
    }else{
        size = CGSizeMake(80,80);
    }
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    UIImage * imga = [scaledImage imageWithRoundedCornersSize:size.width];
    
    //返回新的改变大小后的图片
    return imga;
}
//生成圆角UIIamge 的方法
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius
{
    UIImage *original = self;
    CGRect frame = CGRectMake(0, 0, original.size.width, original.size.height);
    // 开始一个Image的上下文
    UIGraphicsBeginImageContextWithOptions(original.size, NO, 1.0);
    // 添加圆角
    [[UIBezierPath bezierPathWithRoundedRect:frame
                                cornerRadius:cornerRadius] addClip];
    // 绘制图片
    [original drawInRect:frame];
    // 接受绘制成功的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage*)addImageText:(UIImage*)img text:(NSString*)text{
    //1.获取上下文
    UIGraphicsBeginImageContext(img.size);
    //2.绘制图片
    [self drawInRect:CGRectMake(0, 0, 200, 45)];
    //3.绘制水印文字
    CGRect rect = CGRectMake(0, (img.size.height-20)/2, img.size.width, 20);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{
                          NSFontAttributeName:[UIFont systemFontOfSize:16],
                          NSParagraphStyleAttributeName:style,
                          NSForegroundColorAttributeName:[UIColor colorWithRed:(200)/255.0f green:(80)/255.0f blue:(77)/255.0f alpha:1]
                          };
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    //4.获取绘制到得图片
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    return watermarkImage;
}
@end
