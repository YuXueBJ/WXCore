//
//  WXDefines.h
//  WXCore
//
//  Created by 朱洪伟 on 15/8/7.
//  Copyright (c) 2015年 Zhu Hong Wei. All rights reserved.
//

#ifndef WXCore_WXDefines_h
#define WXCore_WXDefines_h


#define RELEASE(__POINTER) { if (nil != (__POINTER)) { CFRelease(__POINTER); __POINTER = nil; } }

/** RGB 颜色转换*/
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define kDefaultHomeBlockTextColor          RGBCOLOR(31, 31, 31)

#define kDefaultHomeTextColor               RGBCOLOR(31, 31, 31)

static NSString * navBackImageName = @"navBackImage";

/*
 * iPhone statusbar 高度
 */
#define PHONE_STATUSBAR_HEIGHT 20
/*
 * iPhone navigationbar 高度
 */
#define PHONE_NAVIGATIONBAR_HEIGHT 44
/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

/*
 *屏幕高度
 */

#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)
/*
 * iPhone 屏幕尺寸
 */
#define PHONE_SCREEN_SIZE (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT))

/**
 版本号
 */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS7  [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] > 6?1:0
#define iOS8  [[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue] > 7?1:0

/**
 默认多语言表
 */
#define RS_CURRENT_LANGUAGE_TABLE  [[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]:@"zh-Hans"


/**
 重写NSLog,Debug模式下打印日志和当前行数
 */
#if DEBUG
#define WXLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define WXLog(FORMAT, ...) nil
#endif

#endif
