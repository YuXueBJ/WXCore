//
//  UIDeviceAddtional.h
//  XYCore
//
//  Created by 朱洪伟 on 15/10/22.
//  Copyright © 2015年 Zhu Hong Wei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIDevice (Addtional)

// 是否是iPhone
+ (BOOL)isiPhone;

// 是否是iPad
+ (BOOL)isiPad;

// 是否是iTouch
+ (BOOL)isiPodTouch;

// 支持拔打电话
+ (BOOL)supportTelephone;

// 支持发送短信
+ (BOOL)supportSendSMS;

// 支持发送邮件
+ (BOOL)supportSendMail;

// 支持摄像头取景
+ (BOOL)supportCamera;

// 以全小写的形式返回设备名称
- (NSString*)modelNameLowerCase;

// 系统版本，以float形式返回
- (CGFloat)systemVersionByFloat;

// 系统版本比较
- (BOOL)systemVersionLowerThan:(NSString*)version;
- (BOOL)systemVersionNotHigherThan:(NSString *)version;
- (BOOL)systemVersionHigherThan:(NSString*)version;
- (BOOL)systemVersionNotLowerThan:(NSString *)version;

- (NSString *) macaddress;


// 内存信息
+ (unsigned int)freeMemory;
+ (unsigned int)usedMemory;

//私有api实现内存警告
//+(void)sendMemoryWarning;

@end
