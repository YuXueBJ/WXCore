//
//  WXImage.m
//  Pods
//
//  Created by zhuhongwei on 16/9/2.
//
//

#import "WXImage.h"

@implementation WXImage

+ (UIImage*)imageForKey:(NSString*)name
{
    NSString * IXMKResourceBundleName = @"/Frameworks/WXCore.framework/WXCore.bundle";
    NSString * resourceName = [NSString stringWithFormat: @"%@%@", [NSBundle mainBundle].bundlePath,IXMKResourceBundleName];
    NSBundle * bundle =  [NSBundle bundleWithPath:resourceName];
    NSString * imageTypeString = @"png";
    
//    NSURL * url = [bundle URLForResource:resourceName withExtension: imageTypeString];
//    if (url) {
//        bundle =[NSBundle bundleWithURL:url];
//    }
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
    
}
@end
