//
//  NSString+Extra.h
//  Roosher
//
//  Created by Levin on 10-9-27.
//  Copyright 2010 Roosher inc. All rights reserved.
//

@interface NSString (Extra)

+ (NSString*)stringWithNewUUID;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSString*)stringByTrimmingBoth;
- (NSString*)stringByTrimmingLeadingWhitespace;

+ (NSString*)formatYearMonthDayHourMinute:(NSTimeInterval)interval;
+ (NSString*)formatYearMonth:(NSTimeInterval)interval;
+ (NSString*)formatYearMonthCN:(NSTimeInterval)interval;
+ (NSString*)formatYearMonthDay:(NSTimeInterval)interval;
+ (NSString*)formatDay:(NSTimeInterval)interval;
+ (NSString*)formatHourMinute:(NSTimeInterval)interval;

- (CGFloat)measureTextHeight:(UIFont *)desFont desWidth:(CGFloat)desWidth;
- (CGSize)measureTextSize:(UIFont *)desFont desWidth:(CGFloat)desWidth;
- (NSString*)trimText;
+ (NSString *)compareCurrentTime:(NSString*) compareDate;

//========================================================================
//时间转换
//获取当前系统的时间戳
+(long)getTimeSp;
//时间戳转换
-(NSString*)getEnUSTimeOut:(NSString*)time;
-(NSString*)getTimeOut:(NSString*)time;
//将时间戳转换成NSDate
+(NSDate *)changeSpToTime:(NSString*)spString;
//将时间戳转换成NSDate,加上时区偏移
+(NSDate*)zoneChange:(NSString*)spString;
//比较给定NSDate与当前时间的时间差，返回相差的秒数
+(long)timeDifference:(NSDate *)date;
//将NSDate按yyyy-MM-dd HH:mm:ss格式时间输出
+(NSString*)nsdateToString:(NSDate *)date;
//将yyyy-MM-dd HH:mm:ss格式时间转换成时间戳
+(long)changeTimeToTimeSp:(NSString *)timeStr;
//获取当前系统的yyyy-MM-dd HH:mm:ss格式时间
+(NSString *)getTime;
//========================================================================


/*
 *  不支持iOS7以下版本
 */
//- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
//- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
//NSDictionary转NSString
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *) jsonStringWithObject:(id) object;
+(NSString *) jsonStringWithString:(NSString *) string;
@end
